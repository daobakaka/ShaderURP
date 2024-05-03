using UnityEngine;

public class SimpleFPSCamera : MonoBehaviour
{
    public float moveSpeed = 5.0f;  // 水平移动速度
    public float verticalMoveSpeed = 3.0f;  // 垂直移动速度
    public float mouseSensitivity = 100.0f;  // 鼠标灵敏度
    public float upDownRange = 60.0f;  // 上下视角移动范围

    private float verticalRotation = 0;  // 垂直方向的旋转角度

    void Start()
    {
        // 设置摄像机初始位置
        transform.position = new Vector3(0, 7, -25);
        transform.eulerAngles = new Vector3(8, 0, 0);
    }

    void Update()
    {
        // 检测是否按下鼠标左键
        if (Input.GetMouseButton(0))
        {
            // 处理鼠标左右移动影响的视角旋转
            float horizontalRotation = Input.GetAxis("Mouse X") * mouseSensitivity * Time.deltaTime;
            transform.Rotate(0, horizontalRotation, 0);
        }

        // 检测是否按下鼠标右键
        if (Input.GetMouseButton(1))
        {
            // 处理鼠标上下移动影响的视角旋转
            verticalRotation -= Input.GetAxis("Mouse Y") * mouseSensitivity * Time.deltaTime;
            verticalRotation = Mathf.Clamp(verticalRotation, -upDownRange, upDownRange);
            Camera camera = GetComponent<Camera>();
            camera.transform.localRotation = Quaternion.Euler(verticalRotation, 0, 0);
        }

        // 处理键盘输入影响的水平移动
        float forwardSpeed = Input.GetAxis("Vertical") * moveSpeed;
        float sideSpeed = Input.GetAxis("Horizontal") * moveSpeed;
        Vector3 speed = new Vector3(sideSpeed, 0, forwardSpeed);
        speed = transform.rotation * speed;
        transform.position += speed * Time.deltaTime;

        // 处理空格键和X键控制的垂直移动
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
