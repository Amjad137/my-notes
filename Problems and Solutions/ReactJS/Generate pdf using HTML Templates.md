```TypeScript
import { CARD_TYPES } from '@/constants/card-constants';
import { CardApplicationFormData, CardApplicationPdf } from '@/types/card-types';
import fs from 'fs';
import handlebars from 'handlebars';
import path from 'path';
import puppeteer from 'puppeteer';

handlebars.registerHelper('times', function (n: number, block: { fn: (i: number) => string }) {
  let accum = '';
  for (let i = 0; i < n; ++i) {
    accum += block.fn(i);
  }
  return accum;
});

handlebars.registerHelper('subtract', function (a: number, b: number) {
  return a - b;
});

export interface CardApplicationPDFOptions {
  filename?: string;
  pageWidth?: number;
  pageHeight?: number;
  margin?: number;
  quality?: number;
  scale?: number;
}

/**
 * Service for generating card application PDFs using Puppeteer and Handlebars
 */
export class CardApplicationPDFService {
  private readonly templatePath: string;

  constructor() {
    // Path to the HTML template
    this.templatePath = path.resolve(
      process.cwd(),
      'src/lib/pdf/templates/card_application/index.html',
    );
  }

  public async generatePDF(
    data: CardApplicationFormData,
    options: Partial<CardApplicationPDFOptions> = {},
  ): Promise<Buffer> {
    try {
      // Compile the HTML template with Handlebars
      const htmlContent = await this.compileTemplate(data);

      // Generate PDF using Puppeteer
      return await this.generatePDFFromHTML(htmlContent, options);
    } catch (error) {
      console.error('❌ [CardApplicationPDFService] Error generating PDF:', error);
      throw new Error(
        `Failed to generate card application PDF: ${error instanceof Error ? error.message : String(error)}`,
      );
    }
  }

  private async compileTemplate(data: CardApplicationFormData): Promise<string> {
    try {
      // Read the HTML template file
      const templateContent = await fs.promises.readFile(this.templatePath, 'utf8');

      if (!templateContent) {
        throw new Error('Template file is empty or could not be read');
      }

      // Compile the template with Handlebars
      const template = handlebars.compile<CardApplicationPdf>(templateContent);

      // Prepare data for the template
      const templateData = await this.prepareTemplateData(data);

      // Render the template with data
      return template(templateData);
    } catch (error) {
      console.error('❌ [CardApplicationPDFService] Error compiling template:', error);
      throw error;
    }
  }

  private async prepareTemplateData(data: CardApplicationFormData): Promise<CardApplicationPdf> {
    // Convert the form data to match the template placeholders
    return {
      logoPath: await this.getLogoAsBase64(),
      branchName: 'Main Branch', // Default value since not in data
      currentDate: this.formatDate(new Date()),
      isSpendCard: data.cardType === CARD_TYPES.SPEND,
      isWebCard: data.cardType === CARD_TYPES.WEB,
      cifDigits: this.splitIntoDigits('123456789012'), // Default CIF since not in data
      cardNoDigits: this.splitIntoDigits('1234567890123456789'), // Default card number since not in data
      isMr: data.title === 'Mr',
      isMrs: data.title === 'Mrs',
      isMiss: data.title === 'Miss',
      isDr: data.title === 'Dr',
      otherTitle: data.title === 'Other' ? data.otherTitle || '' : '',
      fullNameLine1: data.fullName?.split(' ').slice(0, 3).join(' ') || '',
      fullNameLine2: data.fullName?.split(' ').slice(3).join(' ') || '',
      nicDigits: this.splitIntoDigits(data.nic || ''),
      nameOnCard: data.cardName || '',
      addressLine1: data.postalAddress?.split(',').slice(0, 2).join(', ') || '',
      addressLine2: data.postalAddress?.split(',').slice(2).join(', ') || '',
      phoneHome: data.homePhone || '',
      phoneOffice: data.officePhone || '',
      phoneMobile: data.mobilePhone || '',
      dateOfBirth: this.formatDate(data.dateOfBirth),
      isLimit200k: true, // Default to 200k limit
      isSmsPin: data.smsPin || false,
      isPinMailerCollection: data.pinMailer || false,
      signature1: data.declarationName || '',
      pinMailerSignature: data.declarationName || '',
      pinMailerDate: this.formatDate(new Date()),
      cardSignature: data.declarationName || '',
      cardDate: this.formatDate(new Date()),
      authorizedSignatory: 'Authorized Officer', // Default value
      branchUseDate: this.formatDate(new Date()),
      declarationName1: data.declarationName || '',
      declarationName2: data.declarationCardHolder || '',
      applicantSignature: data.declarationName || '',
    };
  }

  private splitIntoDigits(value: string): string[] {
    if (!value) return [];
    return value
      .toString()
      .split('')
      .filter((char) => /\d/.test(char));
  }

  private formatDate(date: Date | string | undefined): string {
    if (!date) return '';

    try {
      const d = new Date(date);
      if (isNaN(d.getTime())) return '';

      const day = d.getDate().toString().padStart(2, '0');
      const month = (d.getMonth() + 1).toString().padStart(2, '0');
      const year = d.getFullYear().toString().slice(-2);

      return `${day} / ${month} / ${year}`;
    } catch {
      return '';
    }
  }

  private async generatePDFFromHTML(
    htmlContent: string,
    options: Partial<CardApplicationPDFOptions>,
  ): Promise<Buffer> {
    try {
      // Launch Puppeteer browser
      const browser = await puppeteer.launch({
        headless: true,
        args: [
          '--no-sandbox',
          '--disable-setuid-sandbox',
          '--disable-dev-shm-usage',
          '--disable-accelerated-2d-canvas',
          '--no-first-run',
          '--no-zygote',
          '--disable-gpu',
        ],
      });

      try {
        // Create a new page
        const page = await browser.newPage();

        // Set content and wait for it to load
        await page.setContent(htmlContent, {
          waitUntil: 'networkidle0',
          timeout: 30000,
        });

        // Wait a bit for any dynamic content to render
        await new Promise((resolve) => setTimeout(resolve, 1000));

        // Generate PDF
        const pdfBuffer = await page.pdf({
          format: 'A4',
          printBackground: true,
          margin: {
            top: options.margin || 15,
            right: options.margin || 15,
            bottom: options.margin || 15,
            left: options.margin || 15,
          },
          scale: options.scale || 1,
          preferCSSPageSize: true,
        });

        // Convert Uint8Array to Buffer
        return Buffer.from(pdfBuffer);
      } finally {
        // Always close the browser
        await browser.close();
      }
    } catch (error) {
      console.error('❌ [CardApplicationPDFService] Error in PDF generation:', error);
      throw error;
    }
  }

  private async getLogoAsBase64(): Promise<string> {
    try {
      // Get the absolute path to the logo image
      const logoPath = path.resolve(process.cwd(), 'public/images/com-bank-logo.png');

      // Read the image file and convert to base64
      const imageBuffer = await fs.promises.readFile(logoPath);
      const base64 = imageBuffer.toString('base64');
      return `data:image/png;base64,${base64}`;
    } catch (error) {
      console.error('❌ [CardApplicationPDFService] Error reading logo:', error);
      // Return a fallback or empty string if logo can't be loaded
      return '';
    }
  }
}

// Export singleton instance
export const cardApplicationPDFService = new CardApplicationPDFService();

```