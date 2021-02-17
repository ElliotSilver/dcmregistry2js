import { activeRegistry, getActiveRelease, registryForRelease, setActiveRelease } from './index.js'


console.log('starting');

let x = getActiveRelease()
console.log("getActiveRelease(): %s", x)

x = registryForRelease('2018a')
console.log("registryForRelease('2018a'): %s", x)

x = registryForRelease('current')
console.log("registryForRelease('current'): %s", x)

x = registryForRelease('cur' + 'rent')
console.log("registryForRelease('cur' + 'rent'): %s", x)

x = activeRegistry()
console.log("activeRegistry(): %s", x)

x = getActiveRelease()
console.log("getActiveRelease(): %s", x)

setActiveRelease('2017c')
console.log("setActiveRelease('2017c')")

x = activeRegistry()
console.log("activeRegistry(): %s", x)
console.log("releaseName: %s", x['releaseName'])

try {
    setActiveRelease('foo')
} catch (e) {
    console.log(e)
}

try {
    x = registryForRelease('2019b')
    console.log("2019b registry: %s", x)
} catch (e) {
    console.log(e)
}

try {
    x = registryForRelease('bar')
    console.log("bar registry: %s", x);
} catch (e) {
    console.log(e);
}

