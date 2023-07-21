<script>
    import {randomMap, randomTowers} from "$lib";

    const map = randomMap();
</script>

<div id="towers">
    <h3>Towers</h3>
    <ul id="tower-list">
        {#each randomTowers(3) as tower }
            <li class="tower-item">{tower.name} ({tower.type})</li>
        {/each}
    </ul>
</div>
<div id="map">
    <h3>Map</h3>
    <span id="map-item">{map.name} ({map.difficulty})</span>
</div>