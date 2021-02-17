import { readdirSync, readFileSync } from 'fs';
import { resolve, join } from 'path';

let registries = new Map();
let active = 'current';

function loadReleaseList() {
    if (registries.size > 0) {
        return;
    }

    let dataDir = resolve('./data');
    readdirSync(dataDir, { withFileTypes: true })
        .filter(ent => ent.isDirectory())
        .forEach(ent => registries.set(ent.name, null));
}

function loadRegistry(releaseName) {
    loadReleaseList();

    if (!registries.has(releaseName)) {
        var s = `DICOM release name {$releaseName} not recognized.`
         throw new Error(s);
    }

    let jsondata = readFileSync(resolve(join('./data', releaseName, 'tagRegistry.json'));
    let data = JSON.parse(jsondata);
    let registry = new Map(data.tags.map(each => [each.tag, each]));
    registry['releaseName'] = data.metadata.release;
    registries.set(releaseName, registry);
    return registry;
}
export function registryForRelease(releaseName) {
    return registries.get(releaseName) || loadRegistry(releaseName);
}

export function activeRegistry() {
    return registryForRelease(active);
}

export function setActiveRelease(releaseName) {
    loadRegistry(releaseName);
    active = releaseName;
}

export function getActiveRelease() {
    return active;
}
