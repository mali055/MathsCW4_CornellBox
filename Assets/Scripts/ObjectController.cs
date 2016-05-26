using UnityEngine;
using System.Collections;

public class ObjectController : MonoBehaviour
{
    public Material[] materials;	

    public void SetMaterial(int index)
    {
        if (materials.Length > index)
            GetComponent<Renderer>().material = materials[index];
    }
	
	
}
