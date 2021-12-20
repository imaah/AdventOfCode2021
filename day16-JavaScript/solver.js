let fs = require('fs');

class Packet {
    constructor(version, type) {
        this.version = version;
        this.type = type;
        this.value = 0;
        this.subs = [];
        this.lastRead = 0;
    }

    setValue(value) {
        this.value = value;
    }

    setSubs(subs) {
        this.subs = subs;
    }

    setLastRead(lastRead) {
        this.lastRead = lastRead;
    }

    getValue() {
        switch(this.type) {
            case 0:
                let sum = 0n;
                for (let sub of this.subs) {
                    sum += sub.getValue();
                }
                return sum;
            case 1:
                let prod = 1n;
                for (let sub of this.subs) {
                    prod *= sub.getValue();
                }
                return prod;
            case 2:
                let min = 9007199254740991n;

                for(let sub of this.subs) {
                    let val = sub.getValue();
                    if(val < min) min = val;
                }
                return min;
            case 3:
                let max = 0n;

                for(let sub of this.subs) {
                    let val = sub.getValue();
                    if(val > max) max = val;
                }
                return max;
            case 4:
                return this.value;
            case 5:
                return BigInt(this.subs[0].getValue() > this.subs[1].getValue());
            case 6:
                return BigInt(this.subs[0].getValue() < this.subs[1].getValue());
            case 7:
                return BigInt(this.subs[0].getValue() == this.subs[1].getValue());
        }
    }

    getVersionSum() {
        let s = this.version;
        for (let sub of this.subs) {
            s += sub.getVersionSum();
        }
        return s;
    }
}

const CONVERTER = {
    "0": "0000",
    "1": "0001",
    "2": "0010",
    "3": "0011",
    "4": "0100",
    "5": "0101",
    "6": "0110",
    "7": "0111",
    "8": "1000",
    "9": "1001",
    "A": "1010",
    "B": "1011",
    "C": "1100",
    "D": "1101",
    "E": "1110",
    "F": "1111",
}

function getAtPosition(s, start, offset) {
    return Number.parseInt(s.substring(start, start + offset), 2);
}

function decode(str, startAt=0) {
    let bin = str;
    for (let key in CONVERTER) {
        bin = bin.replace(new RegExp(key, 'g'), CONVERTER[key]);
    }
    bin = bin.substring(startAt);
    v = getAtPosition(bin, 0, 3);
    type = getAtPosition(bin, 3, 3);
    let packet = new Packet(v, type);
    let lastRead = 6;
    if(type === 4) {
        let prefix = 1n;
        let i = 0;
        let value = 0n;
        while (prefix === 1n) {
            value <<= 4n;
            let v = BigInt(getAtPosition(bin, 6 + 5 * i, 5))
            value += v & 0b1111n;
            prefix = v >> 4n;
            i++;
            lastRead+=5;
        }
        packet.setValue(value);
    } else {
        let i = getAtPosition(bin, 6, 1);
        lastRead ++;
        let subs = [];
        if (i === 1) {
            let numOfSubs = getAtPosition(bin, 7, 11);
            lastRead += 11;
            let offset = startAt + 18;
            for(let _ = 0; _ < numOfSubs; _++) {
                let sub = decode(str, offset);
                offset += sub.lastRead;
                lastRead += sub.lastRead;
                subs.push(sub);
            }
        } else {
            let lenOfSubs = getAtPosition(bin, 7, 15);
            let readLen = 0;
            lastRead += 15;
            let offset = startAt + 22;
            while (readLen < lenOfSubs) {
                let sub = decode(str, offset + readLen);
                readLen += sub.lastRead;
                lastRead += sub.lastRead;
                subs.push(sub);
            }
        }
        packet.setSubs(subs);
    }
    packet.setLastRead(lastRead);
    return packet;
}

let input = new String(fs.readFileSync("input.txt"));
let packet = decode(input.trim());
console.log("Part 1 : ", packet.getVersionSum().toString(10));
console.log("Part 2 : ", packet.getValue().toString(10));