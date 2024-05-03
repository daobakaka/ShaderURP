//UNITY_SHADER_NO_UPGRADE
#ifndef MYHLSLINCLUDE_INCLUDED
#define MYHLSLINCLUDE_INCLUDED

void MyFunctionTest_half(float3 A, float B, out float3 Out)
{
    Out = A * B;
}
//无返回值的写法，_float 是定义数据精度，所有的写法都应遵循此规则进行
float3 MyOtherFunction_float(float3 In)
{
    return In * In;
}
#endif //MYHLSLINCLUDE_INCLUDED