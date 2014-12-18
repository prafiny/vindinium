#ifndef MATRIX_H
#define MATRIX_H

typedef Matrix struct Matrix {
  int ** data;
  size_t size;
};

Matrix * Matrix_create(size_t size);

void Matrix_initialize(Matrix * m, size_t size, int val);

void Matrix_access(Matrix * m, unsigned int i, unsigned int j);

void Matrix_set(Matrix * m, unsigned int i, unsigned int j, int val);

void Matrix_free(Matrix * m);

#endif
