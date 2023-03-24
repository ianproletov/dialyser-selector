#!/usr/bin/env node

import sql from '../index.js';

const result = await sql();
console.log(result);
console.log('done!');
