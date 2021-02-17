import { readdirSync, readFileSync } from 'fs';
import { resolve, join } from 'path';

let releases = new Map();
let activeName = 'current';

function loadReleaseNames() {
    if (releases.size > 0) {
        return;
    }

    readdirSync(resolve('./data'), { withFileTypes: true })
        .filter(ent => ent.isDirectory())
        .forEach(ent => releases.set(ent.name, null));
}

function loadRegistryForReleaseName(releaseName) {
    loadReleaseNames();

    if (!releases.has(releaseName)) {
        throw new Error('DICOM release name not recognized.');
    }

    let jsondata = readFileSync(resolve(join('./data', releaseName, 'tagRegistry.json')));
    let data = JSON.parse(jsondata);
    let registry = new Map(data.tags.map(each => [each.tag, each]));
//    registry['releaseName'] = data.metadata.release
    releases.set(releaseName, registry);
    return registry;
}

export function unloadRegistryForReleaseName(releaseName) {
    if (!releases.has(releaseName)) {
        throw new Error('DICOM release name not recognized');
    }

    releases.set(releaseName, null);
}

export function releaseNames() {
    loadReleaseNames();

    return releases.keys();
}

export function registryForReleaseName(releaseName) {
    return releases.get(releaseName) || loadRegistryForReleaseName(releaseName);
}

export function activeRegistry() {
    return registryForReleaseName(activeReleaseName());
}

export function activateReleaseName(releaseName) {
    loadRegistryForReleaseName(releaseName)
    var oldName = activeName;
    activeName = releaseName;
    return oldName;
}

export function activeReleaseName() {
    return activeName;
}
