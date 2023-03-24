import json2xls from 'json2xls';
import _ from 'lodash';

const map = {
  xls: json2xls,
  json: JSON.stringify,
};

export default (format) => {
  if (!_.has(map, format)) {
    throw new Error(`Unknown format: ${format}`);
  }
  return map[format];
};
