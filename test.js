import { 
    unloadRegistryForReleaseName, 
    releaseNames,
    registryForReleaseName,
    activeRegistry,
    activateReleaseName,
    activeReleaseName
} from './index.js';


console.log('starting');

let x = activeReleaseName()
console.log("activeReleaseName(): %s", x)

x = registryForReleaseName('2018a')
console.log("registryForRelease('2018a'): %s", x)

x = registryForReleaseName('current')
console.log("registryForRelease('current'): %s", x)

x = registryForReleaseName('cur' + 'rent')
console.log("registryForRelease('cur' + 'rent'): %s", x)

x = activeRegistry()
console.log("activeRegistry(): %s", x)

x = activeReleaseName()
console.log("activeReleaseName(): %s", x)

activateReleaseName('2017c')
console.log("activateReleaseName('2017c')")

x = activeRegistry()
console.log("activeRegistry(): %s", x)

try {
    activateReleaseName('foo')
} catch (e) {
    console.log(e)
}

try {
    x = registryForReleaseName('2019b')
    console.log("2019b registry: %s", x)
} catch (e) {
    console.log(e)
}

try {
    x = registryForReleaseName('bar')
    console.log("bar registry: %s", x);
} catch (e) {
    console.log(e);
}

