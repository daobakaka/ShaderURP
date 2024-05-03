using UnityEngine;

public class GhostEffect : MonoBehaviour
{
    public Material ghostMaterial;
    public float blend = 0.5f;
    public RenderTexture ghostTexture;

    void Start()
    {
        ghostTexture = new RenderTexture(Screen.width, Screen.height, 0);
        ghostMaterial.SetFloat("_Blend", blend);
        ghostMaterial.SetTexture("_GhostTex", ghostTexture);
    }

    void Update()
    {
        // Set the blend value based on some logic to fade out the ghost image
        blend = Mathf.Clamp01(blend - Time.deltaTime); // Example fade out logic
        ghostMaterial.SetFloat("_Blend", blend);
    }

    void OnRenderImage(RenderTexture src, RenderTexture dst)
    {
        // Render the current frame with the ghost image onto the screen
        Graphics.Blit(src, dst, ghostMaterial);
        // Copy the current frame to the ghost texture for the next frame
        Graphics.Blit(src, ghostTexture);
        Debug.Log("update");
    }
}
