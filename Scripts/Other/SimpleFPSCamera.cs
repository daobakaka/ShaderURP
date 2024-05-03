using UnityEngine;

public class SimpleFPSCamera : MonoBehaviour
{
    public float moveSpeed = 5.0f;  // ˮƽ�ƶ��ٶ�
    public float verticalMoveSpeed = 3.0f;  // ��ֱ�ƶ��ٶ�
    public float mouseSensitivity = 100.0f;  // ���������
    public float upDownRange = 60.0f;  // �����ӽ��ƶ���Χ

    private float verticalRotation = 0;  // ��ֱ�������ת�Ƕ�

    void Start()
    {
        // �����������ʼλ��
        transform.position = new Vector3(0, 7, -25);
        transform.eulerAngles = new Vector3(8, 0, 0);
    }

    void Update()
    {
        // ����Ƿ���������
        if (Input.GetMouseButton(0))
        {
            // ������������ƶ�Ӱ����ӽ���ת
            float horizontalRotation = Input.GetAxis("Mouse X") * mouseSensitivity * Time.deltaTime;
            transform.Rotate(0, horizontalRotation, 0);
        }

        // ����Ƿ�������Ҽ�
        if (Input.GetMouseButton(1))
        {
            // ������������ƶ�Ӱ����ӽ���ת
            verticalRotation -= Input.GetAxis("Mouse Y") * mouseSensitivity * Time.deltaTime;
            verticalRotation = Mathf.Clamp(verticalRotation, -upDownRange, upDownRange);
            Camera camera = GetComponent<Camera>();
            camera.transform.localRotation = Quaternion.Euler(verticalRotation, 0, 0);
        }

        // �����������Ӱ���ˮƽ�ƶ�
        float forwardSpeed = Input.GetAxis("Vertical") * moveSpeed;
        float sideSpeed = Input.GetAxis("Horizontal") * moveSpeed;
        Vector3 speed = new Vector3(sideSpeed, 0, forwardSpeed);
        speed = transform.rotation * speed;
        transform.position += speed * Time.deltaTime;

        // ����ո����X�����ƵĴ�ֱ�ƶ�
        if (Input.GetKey(KeyCode.Space))
        {
            transform.position += Vector3.up * verticalMoveSpeed * Time.deltaTime;
        }
        if (Input.GetKey(KeyCode.X))
        {
            transform.position += Vector3.down * verticalMoveSpeed * Time.deltaTime;
        }
    }
}
