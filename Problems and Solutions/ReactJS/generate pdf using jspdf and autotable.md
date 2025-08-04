```typescript
import { jsPDF } from 'jspdf';
import autoTable from 'jspdf-autotable';

const [codes, setCodes] = useState<IEntryCode[]>([]);

const handleDownloadPDF = () => {
    if (!codes.length) return;
    const currentDate = new Date().toISOString().split('T')[0];
    const fileName = `Entry_Codes_${currentDate}.pdf`;
    const tableData = codes.map((data) => [
      data.code,
      data.expiresAt ? new Date(data.expiresAt).toLocaleString() : '-',
      capitalize(data.role),
    ]);
    const doc = new jsPDF();
    autoTable(doc, {
      head: [['Code', 'Expire Date', 'Role', 'Signature']],
      body: tableData,
      styles: { fontSize: 10, textColor: '#000' },
      theme: 'grid',
      headStyles: { fillColor: '#104e64', textColor: '#fff' },
      willDrawPage: (data) => {
        doc.text(`Entry Codes for ${capitalize(codes[0].role)}`, data.settings.margin.left, 10, {
          align: 'left',
        });
      },
    });

    doc.save(fileName);
  };
```