using UnityEngine;
using System.Collections;

public class CollectableSpawner : MonoBehaviour {

	public GameObject[] prefabs;

	// Use this for initialization
	void Start () {

		// infinite coin spawning function, asynchronous
		StartCoroutine(SpawnCoins());
		StartCoroutine(SpawnDiamonds());
	}

	// Update is called once per frame
	void Update () {

	}

	IEnumerator SpawnCoins() {

		// start a bit late randomly for first spawning variation
		yield return new WaitForSeconds(Random.Range(1, 3));

		while (true) {
			float yAxisCoinMin = SkyscraperSpawner.SkyscraperYPosition() + 18f;

			// number of coins we could spawn vertically
			int coinsThisRow = Random.Range(1, 4);

			// instantiate all coins in this row separated by some random amount of space
			for (int i = 0; i < coinsThisRow; i++) {
				Instantiate(prefabs[0], new Vector3(26, Random.Range(yAxisCoinMin, 10), 13.5f), Quaternion.identity);
			}

			// pause 1-5 seconds until the next coin spawns
			yield return new WaitForSeconds(Random.Range(1, 5));
		}
	}

	IEnumerator SpawnDiamonds() {

		// start spawn diamonds lately, so it won't spawn immediately at this function call
		yield return new WaitForSeconds(Random.Range(10, 15));

		while (true) {

			float yAxisDiamondMin = SkyscraperSpawner.SkyscraperYPosition() + 18f;

			// prefabs[1] - Diamond Prefab
			Instantiate(prefabs[1], new Vector3(26, Random.Range(yAxisDiamondMin, 10), 13.5f), Quaternion.identity);

			// pause 10-15 seconds until next Diamond spawns
			yield return new WaitForSeconds(Random.Range(10, 15));
		}
	}
}
