import { readFile } from 'fs';
import { dirname, join } from 'path';

const package_path = dirname(require.resolve(
    join('dcmregistry2js', 'package.json')));

readFile(join(package_path, 'tagRegistry.json'), (err, data) => {
    if (err) throw err;
    const tags = JSON.parse(data);
});

readFile(join(package_path, 'uidRegistry.json'), (err, data) => {
    if (err) throw err;
    const uids = JSON.parse(data);
});
    
export const tags = tags
export const uids = uids