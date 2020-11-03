using UnityEngine;
using System.Collections;

public class SkyscraperSpawner : MonoBehaviour {

	public GameObject[] prefabs;
	private static float BaseSpeed = 10f;
	public static float speed;

	// Use this for initialization
	void Start () {

		// reset the speed to base speed when scene reloads
		speed = BaseSpeed;

		// aysnchronous infinite skyscraper spawning
		StartCoroutine(SpawnSkyscrapers());
	}

	// Update is called once per frame
	void Update () {

	}

	IEnumerator SpawnSkyscrapers() {
		while (true) {

			// create a new skyscraper from prefab selection at right edge of screen
			Instantiate(prefabs[Random.Range(0, prefabs.Length)], new Vector3(26, Random.Range(-20, -16), 13.5f),
				Quaternion.identity);

			// randomly increase the speed by 1
			if (Random.Range(1, 4) == 1) {
				speed += 1f;
			}

			// wait between 1-5 seconds for a new skyscraper to spawn
			yield return new WaitForSeconds(Random.Range(2, 6));
		}
	}
}
