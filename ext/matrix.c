#include "matrix.h"
#include "stdlib.h"
#include "string.h"
#include <stdio.h>

Matrix * Matrix_create(unsigned int size, int val){
  Matrix * m;
  if((m = malloc(sizeof(Matrix))) == NULL)
    exit(0);
  Matrix_initialize(m, size, val);
  return m;
}

void Matrix_initialize(Matrix * m, unsigned int size, int val){
  unsigned int i, j;
  m->size = size;
  if((m->data = malloc(sizeof(int *)*size)) == NULL)
    exit(0);
  for(i=0; i<size; i++){
    if((m->data[i] = malloc(sizeof(int)*size)) == NULL)
      exit(0);
    for(j=0; j<size; j++){
      m->data[i][j] = val;
    }
  }
}

int Matrix_access(Matrix * m, unsigned int i, unsigned int j){
  return m->data[i][j];
}

void Matrix_display(Matrix * m){
  unsigned int i, j;
  for(i=0; i<m->size; i++){
    for(j=0; j<m->size; j++){
      printf("%d ", m->data[i][j]);
    }
    printf("\n");
  } 
}

void Matrix_set(Matrix * m, unsigned int i, unsigned int j, int val){
  m->data[i][j] = val;
}

void Matrix_free(Matrix * m){
  unsigned int i;
  for(i=0; i<m->size; i++){
    free(m->data[i]);
  }
  free(m->data);
  free(m);
}
