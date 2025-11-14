#include <iostream>
#include <cuda.h>

using namespace std;

__global__ void AddIntsCUDA(int *a, int *b)
{
    a[0] += b[0];
}

int main()
{
    int x = 5, y = 20;

    int *device_ptr_a, *device_ptr_b;

    cudaMalloc(&device_ptr_a, sizeof(int));
    cudaMalloc(&device_ptr_b, sizeof(int));

    cudaMemcpy(device_ptr_a, &x, sizeof(int), cudaMemcpyHostToDevice);
    cudaMemcpy(device_ptr_b, &y, sizeof(int), cudaMemcpyHostToDevice);

    AddIntsCUDA<<<1, 1>>>(device_ptr_a, device_ptr_b);

    cudaMemcpy(&x, device_ptr_a, sizeof(int), cudaMemcpyDeviceToHost);

    cout << "Answer: " << x << endl;

    cudaFree(device_ptr_a);
    cudaFree(device_ptr_b);

    return 0;
}
