import { readdirSync, readFileSync } from 'fs';
import { resolve, join } from 'path';

let tagReleases = new Map();
let uidReleases = new Map();
let tagActiveName = 'current';
let uidActiveName = 'current';

function loadTagReleaseNames() {
    if (tagReleases.size > 0) {
        return;
    }

    readdirSync(resolve('./data'), { withFileTypes: true })
        .filter(ent => ent.isDirectory())
        .forEach(ent => {
            tagReleases.set(ent.name, null)
        });
}

function loadUidReleaseNames() {
    if (uidReleases.size > 0) {
        return;
    }

    readdirSync(resolve('./data'), { withFileTypes: true })
        .filter(ent => ent.isDirectory())
        .forEach(ent => {
            uidReleases.set(ent.name, null)
        });
}
function loadTagRegistryForReleaseName(releaseName) {
    loadTagReleaseNames();

    if (!tagReleases.has(releaseName)) {
        throw new Error('DICOM release name "' + releaseName + '" not recognized.');
    }

    let jsondata = readFileSync(resolve(join('./data', releaseName, 'tagRegistry.json')));
    let data = JSON.parse(jsondata);
    let registry = new Map(data.tags.map(each => [each.tag, each]));
    tagReleases.set(releaseName, registry);

    // For most releases, directory name matches release name in metainfo.
    // However, the current release uses the "current" directory.
    // List the registry under both names.
    if(releaseName != data.metadata.release) {
        tagReleases.set(data.metadata.release, registry);
    }
    return registry;
}

function loadUidRegistryForReleaseName(releaseName) {
    loadUidReleaseNames();

    if (!uidReleases.has(releaseName)) {
        throw new Error('DICOM release name "' + releaseName + '" not recognized.');
    }

    let jsondata = readFileSync(resolve(join('./data', releaseName, 'uidRegistry.json')));
    let data = JSON.parse(jsondata);
    let registry = new Map(data.uids.map(each => [each.value, each]));
    uidReleases.set(releaseName, registry);

    // For most releases, directory name matches release name in metainfo.
    // However, the current release uses the "current" directory.
    // List the registry under both names.
    if(releaseName != data.metadata.release) {
        uidReleases.set(data.metadata.release, registry);
    }
    return registry;
}

export function tagReleaseNames() {
    loadTagReleaseNames();

    return tagReleases.keys();
}

export function uidReleaseNames() {
    loadUidReleaseNames();

    return uidReleases.keys();
}

export function tagRegistryForReleaseName(releaseName) {
    return tagReleases.get(releaseName) || loadTagRegistryForReleaseName(releaseName);
}

export function uidRegistryForReleaseName(releaseName) {
    return uidReleases.get(releaseName) || loadUidRegistryForReleaseName(releaseName);
}

export function activeTagRegistry() {
    return tagRegistryForReleaseName(activeTagReleaseName());
}

export function activeUidRegistry() {
    return uidRegistryForReleaseName(activeUidReleaseName());
}

export function activateTagReleaseName(releaseName) {
    loadTagRegistryForReleaseName(releaseName)
    var oldName = tagActiveName;
    tagActiveName = releaseName;
    return oldName;
}

export function activateUidReleaseName(releaseName) {
    loadUidRegistryForReleaseName(releaseName)
    var oldName = uidActiveName;
    uidActiveName = releaseName;
    return oldName;
}

export function activeTagReleaseName() {
    return tagActiveName;
}

export function activeUidReleaseName() {
    return uidActiveName;
}
