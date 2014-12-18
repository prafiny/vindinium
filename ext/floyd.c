#include <ruby.h>
#include <stdbool.h>
#include <limits.h>
#include "matrix.h"
#define RB_MATRIX(m) Data_Wrap_Struct( rb_cObject, NULL, Matrix_free, m )
inline Matrix * C_MATRIX(VALUE rm){
  Matrix * cm;
  Data_Get_Struct( rm, Matrix, cm );
  return cm;
}

void Floyd_iter(Matrix * length, Matrix * next){
  unsigned int k,i,j;
  for(k=0; k<length->size; k++){
    for(i=0; i<length->size; i++){
      if(Matrix_access(length, i, k) != -1){
        for(j=i; j<length->size; j++){
          if(Matrix_access(length, k, j) != -1){
            int new = Matrix_access(length, i, k) + Matrix_access(length, k, j);
            if(new < Matrix_access(length, i, j)){
              Matrix_set(length, i, j, new);
              Matrix_set(next, i, j, k);
              Matrix_set(length, j, i, new);
              Matrix_set(next, j, i, k);
            }
          }
        }
      }
    }
  }
}

static unsigned int Tile_get_id(size_t size, VALUE pos){
  return NUM2INT(rb_ary_entry(pos, 0))*size + NUM2INT(rb_ary_entry(pos, 1));
}

static VALUE Tile_get_pos(size_t size, unsigned int id){
  return rb_ary_new3(2, INT2NUM(id / size), INT2NUM(id % size));
}

static VALUE Floyd_initialize(VALUE self)
{
  rb_iv_set(self, "@next", Qnil);
  rb_iv_set(self, "@length", Qnil);
  rb_iv_set(self, "@board", Qnil);
  return self;
}

static VALUE add_neighbour(VALUE jV, VALUE self, int argc, VALUE argv[]){
  Matrix * length = C_MATRIX(rb_iv_get(self, "@length"));
  Matrix * next = C_MATRIX(rb_iv_get(self, "@next"));
  int i = NUM2INT(argv[0]), j = NUM2INT(jV);
  Matrix_set(length, i, j, 1);
  Matrix_set(next, i, j, j);
  return Qnil;  
}

static VALUE Floyd_compute(VALUE self)
{
  VALUE board = rb_iv_get(self, "@board");
  unsigned int size = NUM2INT(rb_iv_get(board, "@size"));
  unsigned int i;
  Matrix * length = Matrix_create(size*2, -1);
  Matrix * next = Matrix_create(size*2, -1);
  rb_iv_set(self, "@next", RB_MATRIX(next));
  rb_iv_set(self, "@length", RB_MATRIX(length));
  for(i=0; i<size; i++){
    VALUE neighbour = rb_funcall(board, rb_intern("passable_neighbours"), 1, Tile_get_pos(size, i));
    VALUE args[1];
    args[0] = INT2NUM(i);
puts(RSTRING_PTR(rb_funcall(neighbour, rb_intern("inspect"), 0)));
    rb_block_call(neighbour, rb_intern("each"), 1, args, RUBY_METHOD_FUNC(add_neighbour), self);
  }
  Floyd_iter(length, next);
  return Qnil;
}

static VALUE Floyd_set_board(VALUE self, VALUE board)
{
  rb_iv_set(self, "@board", board);
  return Qnil;
}

static VALUE Floyd_search_path(VALUE self, VALUE from, VALUE to)
{
  VALUE path = rb_ary_new3(1, from);
  Matrix * next = C_MATRIX(rb_iv_get(self, "@next"));
  VALUE board = rb_iv_get(self, "@board");
  unsigned int size = NUM2INT(rb_iv_get(board, "@size"));
  int u = Tile_get_id(size, from), v = Tile_get_id(size, to);
  if(Matrix_access(next, u, v) == -1)
    return Qnil;

  while(u != v){
    u = Matrix_access(next, u, v);
    rb_ary_push(path, Tile_get_pos(size, u));
  }
  return path;
}

static VALUE Floyd_search_length(VALUE self, VALUE from, VALUE to)
{
  Matrix * length = C_MATRIX(rb_iv_get(self, "@length"));
  return INT2NUM(Matrix_access(length, Tile_get_id(length->size/2, from), Tile_get_id(length->size/2, to)));
}

static VALUE Floyd_search_next(VALUE self, VALUE from, VALUE to)
{
  Matrix * next = C_MATRIX(rb_iv_get(self, "@next"));
  return Tile_get_pos(next->size/2, Matrix_access(next, Tile_get_id(next->size/2, from), Tile_get_id(next->size/2, to)));
}

static VALUE Floyd_get_pos(VALUE self, VALUE pos){
  Matrix * length = C_MATRIX(rb_iv_get(self, "@length"));
  return INT2NUM(Tile_get_id(length->size/2, pos));
}

static VALUE Floyd_get_id(VALUE self, VALUE id){
  Matrix * length = C_MATRIX(rb_iv_get(self, "@length"));
  return Tile_get_pos(length->size/2, NUM2INT(id));
}

void Init_floyd()
{
  // Define a new module
  VALUE Pathfinding = rb_define_module("Pathfinding");
  // Define a new class (inheriting Object) in this module
  VALUE Floyd = rb_define_class_under(Pathfinding, "Floyd", rb_cObject);
  rb_define_method(Floyd, "initialize", Floyd_initialize, 0);
  rb_define_method(Floyd, "compute", Floyd_compute, 0);
  rb_define_method(Floyd, "search_path", Floyd_search_path, 2);
  rb_define_method(Floyd, "search_length", Floyd_search_length, 2);
  rb_define_method(Floyd, "search_next", Floyd_search_next, 2);
  rb_define_method(Floyd, "board=", Floyd_set_board, 1);
  rb_define_method(Floyd, "get_pos", Floyd_get_pos, 1);
  rb_define_method(Floyd, "get_id", Floyd_get_id, 1);
}
