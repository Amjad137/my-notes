
``` typescript

import { saveAs } from 'file-saver';
import * as xlsx from 'xlsx';
import { METER_TYPE } from '../constants/meter.constant';

export const generateAndDownloadExcel = (data, deviceName: string, meterType: METER_TYPE) => {
  let flatData;

    flatData = data.map((item) => ({
      'Date & Time': item.endTime,
      'Usage [kWh]': item.power['Solar+'] - item.power.Grid,
      'Generation [kWh]': item.power.Solar,
      'Grid [kWh]': item.power.Grid,
      'Grid Lower [kWh]': -item.power.Grid,
      'Solar1 [kWh]': item.power.Solar,
      'Solar1+ [kWh]+': item.power['Solar+'],
    }));
  
  const worksheet = xlsx.utils.json_to_sheet(flatData);
  const workbook = xlsx.utils.book_new();
  xlsx.utils.book_append_sheet(workbook, worksheet, 'Power Data');

  const excelBuffer = xlsx.write(workbook, { type: 'array', bookType: 'xlsx' });
  const blob = new Blob([excelBuffer], {
    type: 'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
  });

  saveAs(blob, `PowerData-${deviceName}.xlsx`);
};

```
