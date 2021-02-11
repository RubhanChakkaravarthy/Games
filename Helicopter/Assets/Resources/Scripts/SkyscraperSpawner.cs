using UnityEngine;
using System.Collections;

public class SkyscraperSpawner : MonoBehaviour {

	public GameObject[] prefabs;
	private static float BaseSpeed = 10f;
	public static float speed;

	// represents whether the skyscraper spawned has passed certain distance
	private static bool crossedSkyScraper = true;
	private float counter = 0f;
	private static float SkyscraperY = 0f;

	// Use this for initialization
	void Start () {

		// reset the speed to base speed when scene reloads
		speed = BaseSpeed;

		// aysnchronous infinite skyscraper spawning
		StartCoroutine(SpawnSkyscrapers());
	}

	// Update is called once per frame
	void Update () {

		if (!crossedSkyScraper) {
			counter += speed * Time.deltaTime;

			if (counter > 3.0f) {
				// skyscraper has moved out a certain distance, reset counter
				crossedSkyScraper = true;
				counter = 0f;
			}
		}
	}

	IEnumerator SpawnSkyscrapers() {
		while (true) {

			crossedSkyScraper = false;
			SkyscraperY = Random.Range(-20, -16);

			// create a new skyscraper from prefab selection at right edge of screen
			Instantiate(prefabs[Random.Range(0, prefabs.Length)], new Vector3(26, SkyscraperY, 13.5f),
				Quaternion.identity);

			// randomly increase the speed by 1
			if (Random.Range(1, 4) == 1) {
				speed += 1f;
			}

			// wait between 1-5 seconds for a new skyscraper to spawn
			yield return new WaitForSeconds(Random.Range(2, 6));
		}
	}

	public static float SkyscraperYPosition() {
		// returns recently spawned skyscraperHeight at the starting position
		// if skyscraper has moved certain distance it will return -28
		if (!crossedSkyScraper) {
			return SkyscraperY;
		} else {
			return -28f;
		}
	}
}
