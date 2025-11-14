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


//

#include <iostream>
using namespace std;

__global__ void addition(int *a, int *b)
{
    printf("Block index: %d\n", blockIdx.x);
    printf("Block dimension: %d\n", blockDim.x);
    printf("Thread index: %d\n", threadIdx.x);
    *(a + threadIdx.x) = *(a + threadIdx.x) * *(b + threadIdx.x);


    int id = blockIdx.x* blockDim.x + threadIdx.x;

}

int main()
{
    int a[] = {1, 2, 3, 4, 5};
    int *ptr_a = a;

    int b[] = {10, 20, 30, 40, 50};
    int *ptr_b = b;

    int *device_a;
    if (cudaMalloc(&device_a, sizeof(int) * 5) == cudaSuccess)
    {
        cout << "Successful" << endl;
    }

    int *device_b;
    cudaMalloc(&device_b, sizeof(b));

    if (cudaMemcpy(device_a, ptr_a, sizeof(a), cudaMemcpyHostToDevice) == cudaSuccess)
    {
        cout << "cuda memcopy Successful" << endl;
    }

    cudaMemcpy(device_b, ptr_b, sizeof(int) * 5, cudaMemcpyHostToDevice);

    addition<<<1, 5>>>(device_a, device_b);

    cudaMemcpy(ptr_a, device_a, sizeof(a), cudaMemcpyDeviceToHost);

    // for (int i = 0; i < 5; i++)
    // {
    //     std::cout << a[i] << std::endl;
    // }

    cudaFree(device_a);
    cudaFree(device_b);
}
