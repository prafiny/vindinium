#include "matrix.h"
#include "stdlib.h"

Matrix * Matrix_create(size_t size, int val){
  Matrix * m;
  if(!(m = malloc(sizeof(Matrix))))
    exit(0);
  Matrix_initialize(m, size, val);
  return m;
}

void Matrix_initialize(Matrix * m, size_t size, int val){
  m->size = size;
  if(!(m->data = malloc(sizeof(int *)*size)))
    exit(0);
  int i;
  for(i=0; i<size; i++){
    if(!(m->data[i] = malloc(sizeof(int)*size)))
      exit(0);
    memset(m->data[i], size, val);
  }
}

void Matrix_access(Matrix * m, unsigned int i, unsigned int j){
  return m->data[i][j];
}

void Matrix_set(Matrix * m, unsigned int i, unsigned int j, int val){
  m->data[i][j] = val;
}

void Matrix_free(Matrix * m){
  for(i=0; i<m->size; i++){
    free(m->data[i]);
  }
  free(m->data);
  free(m);
}
