//UNITY_SHADER_NO_UPGRADE
#ifndef MYHLSLINCLUDE_INCLUDED
#define MYHLSLINCLUDE_INCLUDED

void MyFunctionTest_half(float3 A, float B, out float3 Out)
{
    Out = A * B;
}
//�޷���ֵ��д����_float �Ƕ������ݾ��ȣ����е�д����Ӧ��ѭ�˹������
float3 MyOtherFunction_float(float3 In)
{
    return In * In;
}
#endif //MYHLSLINCLUDE_INCLUDED