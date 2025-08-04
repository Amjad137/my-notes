export const updateUserProtectedFieldsSchema = object({
  // Reason for the update (required for audit)
  reason: string().required('Reason for update is required'),

  entityType: mixed<AUDIT_ENTITY_TYPE>()
    .oneOf(pkg.values(AUDIT_ENTITY_TYPE))
    .required('Entity type is required'),

  action: mixed<AUDIT_ACTION>().oneOf(pkg.values(AUDIT_ACTION)).required('Action is required'),
  // Who approved this change (optional additional accountability)
  approvedBy: string().optional(),

  // The actual fields to update, depends on user role
  updatedFields: object({
    studentDetails: object({
      admissionNo: string(),
      parentNic: string().matches(/^(?:\d{9}[vV]|\d{12})$/, 'Please enter a valid NIC number')
    }).optional(),

    principalDetails: object({
      appointedDate: date(),
      isCurrent: string().optional(),
      nic: string().matches(/^(?:\d{9}[vV]|\d{12})$/, 'Please enter a valid nic number')
    }).optional(),

    teacherDetails: object({
      nic: string().matches(/^(?:\d{9}[vV]|\d{12})$/, 'Please enter a valid nic number'),
      appointedDate: date()
    }).optional(),

    parentDetails: object({
      nic: string().matches(/^(?:\d{9}[vV]|\d{12})$/, 'Please enter a valid nic number')
    }).optional()
  }).required('Updated fields are required')
});