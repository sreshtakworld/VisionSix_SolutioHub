import type { PageId } from './navigation';

export type Severity = 'Low' | 'Medium' | 'High' | 'Critical';
export type Frequency = 'One-time' | 'Occasionally' | 'Frequently' | 'Constantly';

export interface ProblemFormData {
  title: string;
  description: string;
  category: string;
  subcategory: string;
  city: string;
  state: string;
  area: string;
  peopleAffected: string;
  severity: Severity | '';
  frequency: Frequency | '';
  affectedGroup: string;
}

export const INITIAL_FORM_DATA: ProblemFormData = {
  title: '',
  description: '',
  category: '',
  subcategory: '',
  city: '',
  state: '',
  area: '',
  peopleAffected: '',
  severity: '',
  frequency: '',
  affectedGroup: '',
};

export const CATEGORIES: Record<string, string[]> = {
  Infrastructure: ['Roads', 'Bridges', 'Public Transport', 'Water Supply', 'Sanitation'],
  Environment: ['Pollution', 'Waste Management', 'Deforestation', 'Water Quality', 'Air Quality'],
  'Public Health': ['Healthcare Access', 'Sanitation', 'Disease Outbreak', 'Mental Health', 'Nutrition'],
  Education: ['School Infrastructure', 'Digital Literacy', 'Teacher Shortage', 'Curriculum', 'Access'],
  'Community Safety': ['Crime', 'Traffic Safety', 'Emergency Services', 'Public Lighting', 'Disaster Preparedness'],
  'Social Services': ['Poverty', 'Housing', 'Employment', 'Elderly Care', 'Youth Programs'],
};

export const SEVERITY_OPTIONS: Severity[] = ['Low', 'Medium', 'High', 'Critical'];
export const FREQUENCY_OPTIONS: Frequency[] = ['One-time', 'Occasionally', 'Frequently', 'Constantly'];

export const SEVERITY_STYLES: Record<Severity, string> = {
  Low: 'bg-accent-50 text-accent-700 border-accent-200',
  Medium: 'bg-brand-50 text-brand-700 border-brand-200',
  High: 'bg-amber-50 text-amber-700 border-amber-200',
  Critical: 'bg-red-50 text-red-700 border-red-200',
};

export type FormErrors = Partial<Record<keyof ProblemFormData, string>>;

export const STEPS = [
  { id: 1, label: 'Problem', description: 'Tell us about the issue' },
  { id: 2, label: 'Location & People', description: 'Where and who is affected' },
  { id: 3, label: 'Urgency', description: 'How urgent is this?' },
  { id: 4, label: 'Review', description: 'Confirm and submit' },
] as const;

export type StepId = (typeof STEPS)[number]['id'];

export interface ReportProblemPageProps {
  onNavigate: (page: PageId) => void;
}
