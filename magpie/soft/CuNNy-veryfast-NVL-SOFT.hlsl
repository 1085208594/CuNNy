// CuNNy veryfast NVL SOFT - https://github.com/funnyplanter/CuNNy

// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
// 
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// 
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
// 
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.


//!MAGPIE EFFECT
//!VERSION 4
//!SORT_NAME CuNNy-SOFT-0000120

//!TEXTURE
Texture2D INPUT;

//!TEXTURE
//!WIDTH INPUT_WIDTH * 2
//!HEIGHT INPUT_HEIGHT * 2
Texture2D OUTPUT;

//!SAMPLER
//!FILTER POINT
SamplerState SP;

//!SAMPLER
//!FILTER LINEAR
SamplerState SL;

//!COMMON
#define O(t, x, y) t.SampleLevel(SP, pos + float2(x, y) * pt, 0)
#define V4 min16float4
#define M4 min16float4x4

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
//!FORMAT R8G8B8A8_UNORM
Texture2D T0;

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
//!FORMAT R8G8B8A8_UNORM
Texture2D T1;

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
//!FORMAT R8G8B8A8_UNORM
Texture2D T2;

//!TEXTURE
//!WIDTH INPUT_WIDTH
//!HEIGHT INPUT_HEIGHT
//!FORMAT R8G8B8A8_UNORM
Texture2D T3;

//!PASS 1
//!DESC in (1x8)
//!BLOCK_SIZE 8
//!NUM_THREADS 64
//!IN INPUT
//!OUT T0, T1
#define L0(x, y) min16float(dot(float3(0.299, 0.587, 0.114), O(INPUT, x, y).rgb))
void Pass1(uint2 blockStart, uint3 tid) {
	float2 pt = float2(GetInputPt());
	uint2 gxy = Rmp8x8(tid.x) + blockStart;
	uint2 sz = GetInputSize();
	if (gxy.x >= sz.x || gxy.y >= sz.y)
		return;
	float2 pos = (gxy + 0.5) * pt;
	min16float s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2;
	V4 r0 = 0.0, r1 = 0.0;
	s0_0_0 = L0(-1.0, -1.0); s0_0_1 = L0(0.0, -1.0); s0_0_2 = L0(1.0, -1.0);
	s0_1_0 = L0(-1.0, 0.0); s0_1_1 = L0(0.0, 0.0); s0_1_2 = L0(1.0, 0.0);
	s0_2_0 = L0(-1.0, 1.0); s0_2_1 = L0(0.0, 1.0); s0_2_2 = L0(1.0, 1.0);
	r0 += V4(-1.384e-02, -2.079e-02, 1.149e-02, 5.623e-02) * s0_0_0;
	r1 += V4(1.593e-02, -3.084e-02, -3.476e-02, 1.042e-01) * s0_0_0;
	r0 += V4(6.242e-02, -1.049e-02, 2.393e-03, -4.830e-02) * s0_0_1;
	r1 += V4(1.133e-02, 7.200e-03, 9.038e-03, -1.890e-01) * s0_0_1;
	r0 += V4(-4.739e-02, 1.358e-02, 5.592e-03, -1.697e-03) * s0_0_2;
	r1 += V4(9.498e-01, 1.429e-01, 2.729e-02, 3.303e-02) * s0_0_2;
	r0 += V4(-7.544e-02, -5.925e-01, -5.385e-02, -3.589e-03) * s0_1_0;
	r1 += V4(-4.614e-03, 4.092e-01, 2.118e-02, 2.783e-02) * s0_1_0;
	r0 += V4(-1.165e-01, 7.207e-01, -1.571e-01, -1.098e+00) * s0_1_1;
	r1 += V4(-9.592e-01, -1.223e+00, 1.034e+00, 1.066e+00) * s0_1_1;
	r0 += V4(-6.835e-01, -9.995e-02, 5.095e-02, 6.621e-02) * s0_1_2;
	r1 += V4(-9.259e-03, 4.753e-01, -1.046e+00, -1.611e-01) * s0_1_2;
	r0 += V4(4.657e-03, -3.895e-01, -1.228e-01, -5.399e-02) * s0_2_0;
	r1 += V4(-7.996e-03, 2.104e-01, 7.879e-03, -1.440e-01) * s0_2_0;
	r0 += V4(9.668e-01, 2.658e-01, 4.802e-01, 1.137e+00) * s0_2_1;
	r1 += V4(6.533e-04, 4.943e-02, -1.702e-02, -6.944e-01) * s0_2_1;
	r0 += V4(-9.560e-02, 1.121e-01, -1.217e-01, -5.620e-02) * s0_2_2;
	r1 += V4(7.270e-03, -4.546e-02, 1.492e-03, -4.219e-02) * s0_2_2;
	r0 += V4(8.168e-04, -5.040e-07, 2.258e-03, -2.882e-04);
	r0 = max(r0, 0.0);
	T0[gxy] = r0;
	r1 += V4(-1.475e-03, 5.553e-04, 3.193e-05, 1.259e-03);
	r1 = max(r1, 0.0);
	T1[gxy] = r1;
}
//!PASS 2
//!DESC conv1 (8x8)
//!BLOCK_SIZE 8
//!NUM_THREADS 64
//!IN T0, T1
//!OUT T2, T3
#define L0(x, y) V4(O(T0, x, y))
#define L1(x, y) V4(O(T1, x, y))
void Pass2(uint2 blockStart, uint3 tid) {
	float2 pt = float2(GetInputPt());
	uint2 gxy = Rmp8x8(tid.x) + blockStart;
	uint2 sz = GetInputSize();
	if (gxy.x >= sz.x || gxy.y >= sz.y)
		return;
	float2 pos = (gxy + 0.5) * pt;
	V4 s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	V4 r0 = 0.0, r1 = 0.0;
	s0_0_0 = L0(-1.0, -1.0); s0_0_1 = L0(0.0, -1.0); s0_0_2 = L0(1.0, -1.0);
	s0_1_0 = L0(-1.0, 0.0); s0_1_1 = L0(0.0, 0.0); s0_1_2 = L0(1.0, 0.0);
	s0_2_0 = L0(-1.0, 1.0); s0_2_1 = L0(0.0, 1.0); s0_2_2 = L0(1.0, 1.0);
	s1_0_0 = L1(-1.0, -1.0); s1_0_1 = L1(0.0, -1.0); s1_0_2 = L1(1.0, -1.0);
	s1_1_0 = L1(-1.0, 0.0); s1_1_1 = L1(0.0, 0.0); s1_1_2 = L1(1.0, 0.0);
	s1_2_0 = L1(-1.0, 1.0); s1_2_1 = L1(0.0, 1.0); s1_2_2 = L1(1.0, 1.0);
	r0 += mul(s0_0_0, M4(-1.371e-01, 9.231e-02, 2.260e-01, -7.910e-03, -9.545e-02, 1.850e-01, -1.888e-02, -2.528e-02, 8.805e-01, -2.415e-02, 1.970e-01, -8.267e-04, -2.942e-01, -1.869e-01, -1.374e-01, -6.794e-03));
	r1 += mul(s0_0_0, M4(-1.262e-01, -1.977e-01, 1.684e-02, 8.650e-02, 1.072e-01, -3.722e-03, -1.525e-02, -4.939e-03, -6.934e-01, -2.043e-02, 4.904e-01, 2.550e-01, 4.834e-01, 2.984e-02, 2.623e-02, 3.205e-02));
	r0 += mul(s0_0_1, M4(3.288e-02, 3.964e-01, -1.297e-01, -4.679e-02, 1.631e-01, -1.414e-01, 1.978e-01, 1.792e-01, -9.082e-01, 7.501e-01, -6.456e-02, -2.198e-01, 2.058e-01, -6.387e-01, 5.898e-02, 5.761e-01));
	r1 += mul(s0_0_1, M4(-7.859e-01, 1.261e-02, -4.521e-01, -6.544e-02, -3.096e-01, 3.345e-02, -5.296e-02, 3.534e-02, -3.924e-01, -3.863e-01, -1.695e-01, -2.799e-01, 4.533e-01, 3.252e-01, 3.288e-01, -1.058e-01));
	r0 += mul(s0_0_2, M4(-1.335e-01, -1.762e-01, 6.158e-02, 6.184e-02, 2.297e-01, 5.273e-01, -1.590e-01, -3.795e-01, -1.870e-01, 6.599e-02, 4.926e-02, 5.481e-01, 1.509e-01, -7.489e-05, -8.183e-02, -6.074e-01));
	r1 += mul(s0_0_2, M4(4.849e-02, 8.528e-02, 2.529e-01, 1.151e-02, -1.025e+00, 7.338e-03, -4.741e-01, -5.252e-02, 3.983e-01, 6.177e-01, -3.620e-01, 3.643e-02, 2.137e-01, -4.074e-01, -1.260e-01, 4.915e-02));
	r0 += mul(s0_1_0, M4(7.563e-01, -3.311e-01, 6.325e-02, -1.694e-01, -7.864e-02, -8.375e-02, -6.664e-02, 5.318e-02, 3.775e-01, -4.052e-02, 2.752e-01, 1.059e-02, -1.152e+00, -3.320e-01, -1.574e-01, -1.219e-02));
	r1 += mul(s0_1_0, M4(2.251e-01, -1.543e-02, 8.770e-01, 2.520e-01, -1.524e-02, 3.585e-02, -1.552e-01, -6.021e-02, -5.047e-01, -1.369e-02, 2.646e-01, 3.451e-02, 7.452e-01, -7.210e-02, -9.708e-01, 3.477e-02));
	r0 += mul(s0_1_1, M4(-1.387e+00, -7.869e-01, -6.074e-01, -4.477e-01, -7.463e-01, 6.661e-01, 1.248e-01, 2.176e-01, -4.847e-01, -7.547e-01, -9.043e-01, -5.526e-01, 1.089e+00, -7.679e-01, 6.621e-01, 1.194e+00));
	r1 += mul(s0_1_1, M4(5.017e-02, -2.509e-01, -4.723e-01, 6.063e-02, -2.929e-01, 9.353e-02, 1.983e-01, -1.808e-02, 1.196e+00, -1.210e-01, -5.191e-03, 1.837e-01, -3.767e-01, 5.918e-01, 4.346e-01, 3.690e-01));
	r0 += mul(s0_1_2, M4(-6.058e-02, 3.359e-01, 6.115e-02, 4.928e-01, -5.527e-01, -5.969e-01, -4.544e-01, -4.599e-02, -3.763e-01, 8.130e-02, 8.769e-03, 2.264e-01, 3.232e-01, 1.028e-01, -2.687e-02, -1.020e+00));
	r1 += mul(s0_1_2, M4(-3.890e-01, 4.416e-01, 2.771e-01, 6.188e-02, -7.303e-02, 2.017e-01, 1.663e-01, 2.529e-01, -4.216e-01, -1.220e-01, -1.516e-01, -1.438e-01, 4.466e-02, -4.441e-01, -1.334e-01, 8.562e-02));
	r0 += mul(s0_2_0, M4(7.608e-02, 1.198e-01, 9.998e-02, 7.075e-02, -1.782e-01, -1.352e-01, -6.932e-02, 1.655e-02, 3.798e-01, 2.324e-01, 1.721e-01, -7.062e-02, -2.319e-01, -1.569e-01, -6.308e-02, -1.216e-01));
	r1 += mul(s0_2_0, M4(-4.446e-01, 4.696e-02, 5.537e-02, 6.552e-02, 1.832e-01, 2.696e-03, -2.394e-02, -2.566e-02, -2.693e-01, -4.077e-02, 6.182e-02, 7.252e-02, 2.435e-01, -6.557e-02, -1.133e-01, -7.106e-02));
	r0 += mul(s0_2_1, M4(-1.506e-01, 8.877e-04, -7.669e-02, -2.379e-02, -2.034e-01, -4.709e-01, -6.473e-02, -1.773e-01, 2.653e-01, -2.307e-01, 2.466e-01, -5.289e-02, 1.228e-01, 3.564e-01, 6.984e-02, 1.335e-01));
	r1 += mul(s0_2_1, M4(-1.290e-01, 6.612e-03, 9.136e-02, 8.487e-03, 3.908e-01, -3.351e-02, -2.141e-02, 6.229e-02, 2.207e-01, 6.932e-04, -2.070e-02, -1.433e-01, -7.158e-01, 1.432e-02, -4.341e-02, 2.660e-02));
	r0 += mul(s0_2_2, M4(-4.288e-03, -3.678e-02, 7.296e-02, -6.939e-03, 1.353e-01, -2.346e-01, 5.503e-02, 2.313e-01, -1.207e-02, -1.440e-01, -2.775e-02, 5.156e-02, -7.227e-02, 1.756e-01, -2.542e-02, 5.735e-03));
	r1 += mul(s0_2_2, M4(-8.715e-02, 1.024e-02, -4.023e-03, -3.184e-02, -1.108e-01, 1.072e-01, -6.288e-02, -5.144e-02, 3.711e-01, 7.382e-02, -1.473e-01, -4.362e-02, -6.262e-01, -5.945e-02, 2.973e-02, 6.361e-02));
	r0 += mul(s1_0_0, M4(3.589e-02, 1.270e-02, -3.916e-03, -4.196e-02, -1.621e-01, -8.130e-02, -8.926e-02, 1.446e-01, -1.104e-01, -3.038e-02, -9.365e-02, 7.984e-02, -5.575e-02, -8.219e-02, 7.199e-02, -4.224e-03));
	r1 += mul(s1_0_0, M4(9.110e-02, -2.239e-02, -1.903e-02, -3.147e-03, -2.675e-02, 1.194e-01, 7.559e-02, -2.913e-02, 1.223e-02, 2.303e-02, -2.412e-01, -7.053e-02, 1.930e-02, -2.334e-02, 1.499e-01, -2.548e-02));
	r0 += mul(s1_0_1, M4(1.556e-02, 1.532e-02, 2.559e-03, -6.745e-02, 9.207e-02, 1.179e-01, 5.652e-02, -2.496e-02, 7.057e-02, -1.985e-01, 9.405e-02, 1.293e-01, -1.181e-01, -3.334e-01, -7.241e-02, -1.370e-01));
	r1 += mul(s1_0_1, M4(-6.435e-02, -2.781e-02, -1.079e-01, -2.248e-02, 1.035e-01, -6.450e-02, 3.027e-01, 1.629e-01, 3.236e-01, -4.391e-02, 1.213e-01, -2.622e-02, -2.235e-01, -2.119e-02, 4.029e-02, 5.849e-02));
	r0 += mul(s1_0_2, M4(1.656e-03, -7.479e-03, -1.306e-02, 1.426e-02, 4.686e-02, -2.708e-02, 6.750e-02, -6.864e-02, 1.880e-02, 1.155e-01, -4.608e-02, -6.598e-02, 3.101e-03, -1.924e-01, 1.905e-02, -5.781e-02));
	r1 += mul(s1_0_2, M4(4.574e-02, -3.141e-02, 7.907e-03, 1.637e-03, -1.017e-01, 6.337e-02, 1.587e-01, 4.503e-02, 4.076e-02, -5.602e-02, -8.868e-02, -1.287e-02, 4.069e-02, -3.023e-01, -2.017e-01, -3.046e-02));
	r0 += mul(s1_1_0, M4(-3.716e-01, -1.029e-01, -1.730e-01, 3.394e-02, 1.394e-01, 1.347e-02, 3.018e-01, 1.724e-01, -5.822e-01, -1.641e+00, 2.024e-01, 4.703e-01, 3.600e-01, 7.012e-01, 2.476e-01, 2.375e-01));
	r1 += mul(s1_1_0, M4(1.235e-02, 7.544e-02, 1.035e-01, -1.635e-03, -6.295e-02, 2.986e-02, 2.242e-01, 1.890e-01, 7.498e-01, 1.879e-01, -2.266e-01, 2.309e-01, -8.571e-01, 6.207e-02, 3.076e-01, 2.608e-01));
	r0 += mul(s1_1_1, M4(-3.155e-01, -7.505e-01, 7.773e-02, 3.994e-01, -4.721e-01, 5.029e-01, -2.092e-01, -7.795e-01, 5.605e-01, -4.301e-01, 2.615e-01, -1.433e+00, -3.213e-01, -1.102e-01, -1.458e-01, -8.574e-01));
	r1 += mul(s1_1_1, M4(5.920e-01, 3.556e-01, 6.620e-01, 8.385e-02, -5.679e-01, -1.483e-01, -2.968e-01, -4.091e-02, 1.085e+00, -7.012e-01, 4.713e-01, 1.304e-02, -2.457e+00, -5.460e-01, -2.438e-01, -2.105e-01));
	r0 += mul(s1_1_2, M4(3.193e-02, -3.269e-02, -3.490e-02, -1.507e-01, -3.623e-02, 4.663e-01, 7.529e-02, 7.987e-01, 2.155e-01, 4.716e-04, 1.887e-02, -3.447e-01, -5.527e-01, -6.013e-01, -1.509e-01, 5.020e-01));
	r1 += mul(s1_1_2, M4(3.641e-02, -2.072e-01, -2.223e-01, -6.154e-02, -5.270e-01, 7.804e-01, 4.795e-01, 3.687e-02, 2.297e-01, -3.802e-01, -2.163e-01, -5.291e-02, -1.356e-02, 4.278e-01, -8.372e-02, -3.704e-02));
	r0 += mul(s1_2_0, M4(-4.387e-01, -8.894e-02, 1.902e-01, 4.800e-01, -8.641e-03, 1.326e-01, -9.301e-02, 3.104e-02, -8.171e-02, 6.627e-01, 3.069e-01, 3.613e-01, 2.586e-01, 2.006e-01, 1.244e-01, 9.713e-02));
	r1 += mul(s1_2_0, M4(1.768e-01, 1.008e-01, -1.043e+00, -1.308e-01, -3.350e-01, 7.339e-03, -3.121e-02, 1.542e-02, -9.030e-01, -2.139e-02, -5.991e-01, 1.643e-01, -3.365e-01, 2.461e-02, -3.966e-02, 4.913e-02));
	r0 += mul(s1_2_1, M4(1.040e+00, 8.232e-01, 6.633e-01, -1.560e-01, -8.571e-02, -5.621e-01, -2.190e-01, 2.529e-01, 6.532e-01, 1.129e+00, 3.679e-01, -3.686e-01, -2.943e-01, -2.153e-01, -1.479e-01, -2.822e-01));
	r1 += mul(s1_2_1, M4(-1.106e+00, 2.136e-01, 2.484e-01, 5.085e-02, 5.373e-01, 8.762e-02, 1.032e-01, -3.209e-02, -6.772e-01, 7.301e-02, 8.721e-02, 6.043e-02, 1.889e-01, -9.797e-02, 1.927e-01, -6.018e-02));
	r0 += mul(s1_2_2, M4(2.889e-02, -2.145e-01, -2.507e-03, -3.856e-01, 5.921e-02, -1.404e-01, 6.616e-02, -7.651e-02, 5.823e-02, -1.008e-01, -1.323e-01, -2.330e-01, 1.048e-01, 1.689e-03, 6.178e-02, 1.858e-01));
	r1 += mul(s1_2_2, M4(2.086e-01, -3.370e-01, -2.099e-01, 2.452e-02, 1.855e-01, 6.018e-02, 9.872e-02, -7.589e-02, 2.461e-02, -8.979e-02, 4.820e-04, 6.189e-02, 7.643e-02, 7.410e-02, -1.655e-01, 1.239e-03));
	r0 = max(r0, 0.0);
	T2[gxy] = r0;
	r1 = max(r1, 0.0);
	T3[gxy] = r1;
}
//!PASS 3
//!DESC conv2 (8x4)
//!BLOCK_SIZE 8
//!NUM_THREADS 64
//!IN T2, T3
//!OUT T0
#define L0(x, y) V4(O(T2, x, y))
#define L1(x, y) V4(O(T3, x, y))
void Pass3(uint2 blockStart, uint3 tid) {
	float2 pt = float2(GetInputPt());
	uint2 gxy = Rmp8x8(tid.x) + blockStart;
	uint2 sz = GetInputSize();
	if (gxy.x >= sz.x || gxy.y >= sz.y)
		return;
	float2 pos = (gxy + 0.5) * pt;
	V4 s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2, s1_0_0, s1_0_1, s1_0_2, s1_1_0, s1_1_1, s1_1_2, s1_2_0, s1_2_1, s1_2_2;
	V4 r0 = 0.0;
	s0_0_0 = L0(-1.0, -1.0); s0_0_1 = L0(0.0, -1.0); s0_0_2 = L0(1.0, -1.0);
	s0_1_0 = L0(-1.0, 0.0); s0_1_1 = L0(0.0, 0.0); s0_1_2 = L0(1.0, 0.0);
	s0_2_0 = L0(-1.0, 1.0); s0_2_1 = L0(0.0, 1.0); s0_2_2 = L0(1.0, 1.0);
	s1_0_0 = L1(-1.0, -1.0); s1_0_1 = L1(0.0, -1.0); s1_0_2 = L1(1.0, -1.0);
	s1_1_0 = L1(-1.0, 0.0); s1_1_1 = L1(0.0, 0.0); s1_1_2 = L1(1.0, 0.0);
	s1_2_0 = L1(-1.0, 1.0); s1_2_1 = L1(0.0, 1.0); s1_2_2 = L1(1.0, 1.0);
	r0 += mul(s0_0_0, M4(-8.191e-02, -8.363e-02, -1.372e-01, -3.144e-02, -1.939e-02, -7.693e-03, 3.974e-02, 2.484e-02, -6.860e-03, 3.022e-03, 5.416e-02, 1.784e-02, -2.435e-02, -4.894e-03, -3.896e-03, -1.546e-02));
	r0 += mul(s0_0_1, M4(5.688e-02, -8.175e-03, 4.134e-02, 1.154e-02, 8.232e-02, 8.842e-02, 1.353e-01, -3.359e-02, 4.335e-02, 1.599e-01, 1.399e-01, 5.273e-02, -1.719e-02, -1.615e-02, -2.418e-02, -5.907e-02));
	r0 += mul(s0_0_2, M4(-6.994e-02, -1.290e-03, -1.586e-02, -7.342e-02, 1.894e-02, 3.136e-02, 1.107e-02, 1.985e-02, -1.086e-02, 3.841e-02, 3.090e-02, -2.496e-02, 1.351e-04, 2.563e-03, -2.089e-02, -1.225e-02));
	r0 += mul(s0_1_0, M4(4.655e-02, -1.018e-01, 8.531e-02, 1.043e-01, -2.046e-01, -5.434e-02, -2.588e-01, -1.422e-01, 2.901e-01, 6.328e-02, 1.184e-01, -1.626e-01, -1.911e-01, 2.175e-02, -1.675e-01, -4.952e-02));
	r0 += mul(s0_1_1, M4(-2.822e-01, 1.084e-01, -4.803e-01, -3.098e-01, 2.044e-01, -3.662e-01, -3.723e-01, -1.171e-01, 3.389e-01, 2.907e-01, 3.597e-01, 1.489e-01, -3.643e-01, -7.716e-01, -3.371e-01, -4.502e-01));
	r0 += mul(s0_1_2, M4(-7.088e-02, -1.729e-01, -9.048e-03, -8.342e-02, -2.426e-02, -2.374e-01, -4.895e-02, -1.235e-01, 1.237e-01, 1.645e-02, 2.293e-02, 9.360e-02, -5.746e-02, 8.888e-03, -3.000e-02, -4.827e-02));
	r0 += mul(s0_2_0, M4(7.684e-02, -1.804e-02, 4.264e-02, 2.810e-02, 4.248e-02, 2.803e-04, -5.372e-02, -1.816e-02, -8.310e-02, 7.123e-03, 4.258e-02, -2.535e-02, -9.036e-02, -2.165e-02, -5.082e-02, -4.854e-02));
	r0 += mul(s0_2_1, M4(-5.266e-02, 1.680e-03, -2.255e-03, -4.376e-02, -8.729e-02, -9.438e-02, 9.369e-03, -5.688e-02, -2.113e-02, 4.924e-02, -3.289e-02, 2.765e-02, 1.729e-02, -6.734e-02, -3.812e-02, -3.105e-02));
	r0 += mul(s0_2_2, M4(-2.731e-02, -5.145e-02, -6.123e-03, -4.286e-02, 3.522e-02, 1.184e-02, -7.198e-03, 2.665e-02, 3.845e-03, -2.493e-02, -1.217e-02, -1.580e-02, -3.698e-02, -1.037e-02, -3.660e-02, -4.988e-02));
	r0 += mul(s1_0_0, M4(-3.988e-02, -2.783e-02, -3.335e-02, -2.959e-02, -7.197e-03, -3.057e-02, -5.191e-02, 4.534e-02, 7.310e-03, -2.620e-03, 1.633e-02, -5.077e-03, -2.677e-02, -2.184e-02, -6.667e-02, -3.211e-02));
	r0 += mul(s1_0_1, M4(1.952e-02, 4.503e-02, 2.216e-02, -4.491e-03, 3.165e-02, -1.713e-02, 3.937e-02, 4.108e-02, -2.028e-02, 3.477e-02, 8.736e-04, -4.106e-02, -2.801e-02, -8.991e-02, -1.219e-01, -2.866e-02));
	r0 += mul(s1_0_2, M4(-8.488e-03, -2.807e-01, -2.406e-02, 2.318e-02, -3.707e-03, -3.417e-03, 8.829e-03, 3.217e-03, -1.647e-02, -1.320e-02, -8.530e-03, -2.541e-02, 1.730e-02, -4.762e-02, -2.699e-02, 1.374e-02));
	r0 += mul(s1_1_0, M4(-5.017e-03, -6.277e-02, -2.897e-01, -6.509e-02, 3.470e-01, -1.574e-02, 1.694e-01, -8.877e-02, -8.503e-03, -7.455e-03, 7.225e-03, -4.396e-02, -1.411e-01, -6.105e-02, -3.747e-02, 1.730e-01));
	r0 += mul(s1_1_1, M4(-1.342e-01, -2.368e-01, -4.145e-01, 1.377e-01, 6.135e-01, 8.809e-01, 6.484e-01, 8.952e-01, -1.170e-01, -1.497e-01, -4.800e-01, -2.344e-01, 1.851e-01, 3.300e-01, 5.432e-01, 3.916e-01));
	r0 += mul(s1_1_2, M4(5.281e-02, -8.613e-02, 5.844e-02, 4.729e-02, -2.908e-03, -1.475e-02, -7.594e-03, -5.585e-03, 9.623e-03, -1.851e-01, 6.286e-03, -1.537e-02, -2.794e-02, 9.902e-02, -4.585e-02, 1.666e-03));
	r0 += mul(s1_2_0, M4(5.393e-02, -1.855e-02, 1.160e-01, -6.699e-04, -5.774e-02, -7.947e-03, -4.428e-02, 1.265e-01, 4.254e-02, -1.927e-02, 4.154e-02, -4.786e-02, 1.647e-01, -7.742e-03, 1.393e-02, 3.209e-03));
	r0 += mul(s1_2_1, M4(-6.345e-02, 1.238e-01, 1.054e-01, 5.855e-02, 2.374e-01, 3.570e-02, 4.004e-02, 1.470e-01, -1.866e-01, 6.963e-02, 5.602e-02, -2.027e-03, -2.212e-01, -2.238e-02, 1.968e-02, -7.987e-02));
	r0 += mul(s1_2_2, M4(-5.984e-03, 4.337e-02, -1.461e-04, 3.961e-02, 3.571e-02, -3.771e-02, 9.698e-03, 1.254e-02, -3.168e-02, 3.186e-02, -4.860e-03, -9.288e-03, -4.882e-02, 1.035e-02, -5.822e-02, -3.567e-02));
	r0 = max(r0, 0.0);
	T0[gxy] = r0;
}
//!PASS 4
//!DESC out-shuffle (4x4)
//!BLOCK_SIZE 16
//!NUM_THREADS 64
//!IN INPUT, T0
//!OUT OUTPUT
#define L0(x, y) V4(O(T0, x, y))
void Pass4(uint2 blockStart, uint3 tid) {
	float2 pt = float2(GetInputPt());
	uint2 gxy = (Rmp8x8(tid.x) << 1) + blockStart;
	uint2 sz = GetOutputSize();
	if (gxy.x >= sz.x || gxy.y >= sz.y)
		return;
	float2 pos = ((gxy >> 1) + 0.5) * pt;
	V4 s0_0_0, s0_0_1, s0_0_2, s0_1_0, s0_1_1, s0_1_2, s0_2_0, s0_2_1, s0_2_2;
	V4 r0 = 0.0;
	s0_0_0 = L0(-1.0, -1.0); s0_0_1 = L0(0.0, -1.0); s0_0_2 = L0(1.0, -1.0);
	s0_1_0 = L0(-1.0, 0.0); s0_1_1 = L0(0.0, 0.0); s0_1_2 = L0(1.0, 0.0);
	s0_2_0 = L0(-1.0, 1.0); s0_2_1 = L0(0.0, 1.0); s0_2_2 = L0(1.0, 1.0);
	r0 += mul(s0_0_0, M4(2.598e-02, 1.593e-04, -4.246e-02, -6.870e-03, 1.979e-02, -2.292e-02, 3.552e-03, 3.418e-03, -1.082e-02, -8.405e-04, 2.897e-02, 4.542e-03, 4.880e-02, 3.257e-05, -6.454e-03, -6.512e-04));
	r0 += mul(s0_0_1, M4(7.546e-02, 4.445e-01, -2.549e-01, -1.156e-01, 2.261e-01, -2.882e-01, 3.002e-02, 3.218e-02, -5.021e-01, -2.056e-01, 1.900e-01, 6.860e-02, 2.628e-01, 2.230e-01, -5.787e-03, -2.841e-03));
	r0 += mul(s0_0_2, M4(-2.028e-01, -5.765e-01, 4.028e-02, -1.175e-01, -1.713e-02, 1.003e-01, -2.545e-03, 4.404e-03, -3.421e-03, 6.927e-02, 1.745e-02, 1.590e-01, 1.626e-01, 2.823e-01, -3.901e-02, -5.628e-02));
	r0 += mul(s0_1_0, M4(-2.335e-02, -3.334e-04, 4.219e-02, 7.906e-03, -9.880e-03, -8.618e-02, 7.268e-03, 6.622e-03, -1.049e-03, 3.363e-03, -3.378e-02, -6.283e-03, 1.499e-01, -2.240e-03, 2.297e-01, 1.975e-04));
	r0 += mul(s0_1_1, M4(8.694e-02, -5.158e-03, 2.543e-01, 2.250e-01, 4.736e-01, -1.603e-01, 3.807e-01, -8.551e-01, 4.141e-02, 2.077e-01, -7.168e-01, -9.700e-02, -6.465e-01, -1.407e-01, -7.338e-02, 5.020e-01));
	r0 += mul(s0_1_2, M4(-4.602e-02, -6.655e-03, 1.252e-01, 9.900e-02, -1.606e-02, 6.449e-02, 6.015e-03, 1.743e-01, -1.423e-02, 3.324e-01, 2.062e-02, 2.195e-01, 5.505e-02, -2.783e-01, -1.140e-01, -3.468e-01));
	r0 += mul(s0_2_0, M4(-5.508e-04, 1.712e-04, -5.889e-04, -1.189e-03, -1.948e-02, -2.830e-04, -9.237e-03, -3.815e-02, 4.375e-03, -8.722e-04, -4.113e-03, 2.142e-03, 1.710e-02, 9.988e-04, 9.764e-03, -8.487e-04));
	r0 += mul(s0_2_1, M4(1.189e-03, 4.201e-04, 3.351e-03, 3.091e-03, -2.678e-02, -1.376e-03, 5.855e-02, 7.837e-02, -8.442e-03, 2.472e-03, 6.532e-02, 4.795e-02, 8.513e-03, -4.480e-03, -1.010e-01, -8.530e-02));
	r0 += mul(s0_2_2, M4(-9.809e-04, -7.654e-04, -5.877e-03, -1.106e-02, -1.639e-03, -1.412e-06, -3.071e-06, 1.657e-02, 1.862e-02, 5.453e-04, -3.162e-02, 2.930e-02, -6.363e-03, -2.944e-03, 2.941e-02, -3.517e-02));
	r0 += V4(-2.046e-08, -4.543e-10, -2.836e-08, -6.854e-10);
	static const float3x3 RY = {0.299, 0.587, 0.114, -0.169, -0.331, 0.5, 0.5, -0.419, -0.081}, YR = {1, -0.00093, 1.401687, 1, -0.3437, -0.71417, 1, 1.77216, 0.00099};
	float2 opt = float2(GetOutputPt());
	float2 fpos = (float2(gxy) + 0.5) * opt;
	float3 yuv;
	yuv = mul(RY, INPUT.SampleLevel(SL, fpos + float2(0.0, 0.0) * opt, 0).rgb);
	OUTPUT[gxy + int2(0, 0)] = float4(mul(YR, float3(saturate(yuv.r + r0.x), yuv.yz)), 1.0);
	yuv = mul(RY, INPUT.SampleLevel(SL, fpos + float2(1.0, 0.0) * opt, 0).rgb);
	OUTPUT[gxy + int2(1, 0)] = float4(mul(YR, float3(saturate(yuv.r + r0.y), yuv.yz)), 1.0);
	yuv = mul(RY, INPUT.SampleLevel(SL, fpos + float2(0.0, 1.0) * opt, 0).rgb);
	OUTPUT[gxy + int2(0, 1)] = float4(mul(YR, float3(saturate(yuv.r + r0.z), yuv.yz)), 1.0);
	yuv = mul(RY, INPUT.SampleLevel(SL, fpos + float2(1.0, 1.0) * opt, 0).rgb);
	OUTPUT[gxy + int2(1, 1)] = float4(mul(YR, float3(saturate(yuv.r + r0.w), yuv.yz)), 1.0);
}
