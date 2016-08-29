using UnityEngine;
using System.Collections;

public class MyBouncingBall : MonoBehaviour {

    private Vector3 _position = new Vector3();
    private float _sin = 0f;
    private float _increment = 0f;

	// Use this for initialization
	void Start () {
        _position = transform.position;
	}
	
	// Update is called once per frame
	void Update () {
        transform.position = _position + new Vector3(0f, Mathf.Sin(Time.time), 0f);

        _sin = Mathf.Sin(_increment + 3.14159265f / 100f);
        _increment += 1.0f;
        if (_increment >= 360) _increment -= 360;
        Debug.Log("_sin = " + _sin + "\n_increment = " + _increment);
	}
}
