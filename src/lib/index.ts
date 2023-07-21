import {MAPS, TOWERS} from "$lib/definitions";
import type {Map, Tower} from "$lib/models";

function distinctRandomValues(count: number, max: number): Set<number> {
    const nums: Set<number> = new Set();
    while (nums.size !== count) {
        nums.add((Math.floor(Math.random() * 100)) % max);
    }

    return nums;
}

export function randomTowers(count: number): Tower[] {
    const values = distinctRandomValues(count, TOWERS.length);
    return Array.from(values).map((randomNumber: number) =>
        // randomNumber is guaranteed to be 0 < {randomNumber} < TOWERS.length
        // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
        TOWERS.at(randomNumber)!);
}

export function randomMap(): Map {
    // randomNumber is guaranteed to be 0 < {randomNumber} < MAPS.length
    // eslint-disable-next-line @typescript-eslint/no-non-null-assertion
    return MAPS.at(Math.floor(Math.random() * 100) % MAPS.length)!;
}
