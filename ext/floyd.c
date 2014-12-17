#include <ruby.h>

/*static VALUE myclass_mymethod(
  VALUE rb_self,
  VALUE rb_param1,
  VALUE rb_param2,
  VALUE rb_param3)
{
  // Code executed when calling my_method on an object of class MyModule::MyClass
}*/
 
static VALUE Floyd_initialize(VALUE self)
{
  rb_iv_set(self, "@next", Qnil);
  rb_iv_set(self, "@length", Qnil);
  rb_iv_set(self, "@next", Qnil);
	rb_iv_set(self, "@board", Qnil);
}

static VALUE Floyd_compute(VALUE self)
{
	rb_iv_set(self, "@next", Qnil);
}

static VALUE Floyd_set_board(VALUE self, VALUE board)
{
	rb_iv_set(self, "@next", board);
}

static VALUE Floyd_search_path(VALUE self, VALUE from, VALUE to)
{

}

static VALUE Floyd_search_length(VALUE self, VALUE from, VALUE to)
{

}

static VALUE Floyd_search_next(VALUE self, VALUE from, VALUE to)
{

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
  rb_define_method(Floyd, "board =", Floyd_set_board, 1);

}
