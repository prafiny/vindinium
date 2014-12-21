#ifndef MATRIX_H
#define MATRIX_H

typedef struct Matrix {
  int ** data;
  unsigned int size;
} Matrix;

Matrix * Matrix_create(unsigned int size, int val);

void Matrix_initialize(Matrix * m, unsigned int size, int val);

int Matrix_access(Matrix * m, unsigned int i, unsigned int j);

void Matrix_display(Matrix * m);

void Matrix_set(Matrix * m, unsigned int i, unsigned int j, int val);

void Matrix_free(Matrix * m);

#endif
