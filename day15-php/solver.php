<?php
define('SIZE', 100);

function get_index($x, $y, $size=SIZE) {
    return $y * $size + $x;
}

function get_val($map, $x, $y, $size=SIZE) {
    if (0 <= $x && $x < $size && 0 <= $y && $y < $size) {
        return $map[get_index($x, $y, $size)];
    }
    return NULL;
}

function get_min($queue, $dist) {
    $min_idx = -1;
    $min = INF;

    foreach ($queue as $elem) {
        if($dist[$elem] < $min) {
            $min = $dist[$elem];
            $min_idx = $elem;
        }
    }

    return $min_idx;
}

function dijkstra($arr, $sx, $sy, $ex, $ey, $size=SIZE) {
    $dist = [];
    $prev = [];
    $queue = [];
    
    foreach ($arr as $idx => $_) {
        $dist[$idx] = INF;
        $prev[$idx] = NULL;
        array_push($queue, $idx);
    }

    $dist[get_index($sx, $sy, $size)] = 0;

    while (!empty($queue)) {
        $idx = get_min($queue, $dist);
        if ($idx == -1) break;
        $ux = $idx % $size;
        $uy = ($idx - $ux) / $size;
        $neighbors = [[1, 0], [-1, 0], [0, 1], [0, -1]];

        foreach ($neighbors as $neighbor) {
            $nx = $ux + $neighbor[0];
            $ny = $uy + $neighbor[1];
            $nidx = get_index($nx, $ny, $size);
            $val = get_val($arr, $nx, $ny, $size);

            if($val == NULL) continue;

            $alt = $dist[$idx] + $arr[$nidx];
        
            if($alt < $dist[$nidx]) {
                $dist[$nidx] = $alt;
                $prev[$nidx] = $idx;
            }
        }

        unset($queue[$idx]);
    }

    return get_val($dist, $ex, $ey, $size);
}

if ($file = fopen("input.txt", "r")) {
    $nline = 0;
    
    while (!feof($file)) {
        $line = array_map('intval', str_split(trim(fgets($file)), 1));
        if(empty($line)) continue;

        for ($i=0; $i < sizeof($line); $i++) {
            $inputs[$nline * SIZE + $i] = $line[$i]; // admitting that every line has the same size.
        }
        $nline ++;
    }
    fclose($file);
}

echo "Part 1 : " . dijkstra($inputs, 0, 0, SIZE - 1, SIZE - 1) . "\n";

$extended = [];
for($y = 0; $y < SIZE * 5; $y++) {
    for($x = 0; $x < SIZE * 5; $x++) {
        $extended[$y * SIZE * 5 + $x] = get_val($inputs, $x % SIZE, $y % SIZE) + floor($x / SIZE) + floor($y / SIZE);
    
        if($extended[$y * SIZE * 5 + $x] > 9) {
            $extended[$y * SIZE * 5 + $x] = $extended[$y * SIZE * 5 + $x] % 9;
        }
    }
}

echo "Take a break, drink a coffee and come back !\n";
echo "Part 2 : " . dijkstra($extended, 0, 0, SIZE * 5 - 1, SIZE * 5 - 1, SIZE * 5) . "\n";
