import { 
    tagRegistryForReleaseName,
    activeTagRegistry,
    activateTagReleaseName,
    activeTagReleaseName
} from './index.js';


console.log('starting');

let x = activeTagReleaseName()
console.log("activeReleaseName(): %s", x)

x = tagRegistryForReleaseName('2018a')
console.log("registryForRelease('2018a'): %s", x)

x = tagRegistryForReleaseName('current')
console.log("registryForRelease('current'): %s", x)

x = tagRegistryForReleaseName('cur' + 'rent')
console.log("registryForRelease('cur' + 'rent'): %s", x)

x = activeTagRegistry()
console.log("activeRegistry(): %s", x)

x = activeTagReleaseName()
console.log("activeReleaseName(): %s", x)

activateTagReleaseName('2017c')
console.log("tagActivateReleaseName('2017c')")

x = activeTagRegistry()
console.log("activeRegistry(): %s", x)

try {
    activateTagReleaseName('foo')
} catch (e) {
    console.log(e)
}

try {
    x = tagRegistryForReleaseName('2019b')
    console.log("2019b registry: %s", x)
} catch (e) {
    console.log(e)
}

try {
    x = tagRegistryForReleaseName('bar')
    console.log("bar registry: %s", x);
} catch (e) {
    console.log(e);
}

