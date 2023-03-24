import { promises as fs } from 'fs';
import sql from 'mssql';
import _ from 'lodash';
import format from './formatters/index.js';

const config = {
  user: 'powerbi_connector',
  password: '1254',
  database: 'bi_analytics',
  server: '10.1.16.104',
  pool: {
    max: 10,
    min: 0,
    idleTimeoutMillis: 30000,
  },
  options: {
    encrypt: false,
    trustServerCertificate: true,
  },
};

export default async (formatType = 'json') => {
  try {
    await sql.connect(config);
    const sqlQuery = await fs.readFile('src/sql/dialysersgroup.sql', 'utf-8');
    const result = await sql.query(sqlQuery);
    const { recordset } = result;
    const summary = _.countBy(recordset, 'recommendedDialyser');
    const resultData = Object.entries(summary)
      .reduce((acc, [key, value]) => {
        const ratio = Math.round((value * 10000) / recordset.length) / 10000;
        return { ...acc, [key]: ratio };
      }, {});
    return format(formatType)(resultData);
    // await fs.writeFile('data.xls', xls, 'binary');
  } catch (err) {
    console.error(err);
    throw err;
  }
};
