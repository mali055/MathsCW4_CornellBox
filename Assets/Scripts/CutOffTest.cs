using UnityEngine;
using System.Collections;

[ExecuteInEditMode]
public class CutOffTest : MonoBehaviour {

	public GameObject hollow;

	Renderer _renderer;
	Renderer _hollowRenderer;

	void Start () 
	{
		_renderer = gameObject.GetComponent<Renderer>();
		_hollowRenderer = hollow.GetComponent<Renderer>();
		
		_renderer.sharedMaterial.SetMatrix("_hollowWTL",_hollowRenderer.worldToLocalMatrix);
	}
	
	void Update () {

		_renderer = gameObject.GetComponent<Renderer>();
		_hollowRenderer = hollow.GetComponent<Renderer>();
		
		_renderer.sharedMaterial.SetMatrix("_hollowWTL",_hollowRenderer.worldToLocalMatrix);
		//Debug.Log(_hollowRenderer.worldToLocalMatrix);

	
	}
}
