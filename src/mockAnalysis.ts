import type { ProblemFormData, Severity } from './reportProblemTypes';

export interface AIAnalysis {
  category: string;
  subcategory: string;
  severity: string;
  urgency: string;
  estimatedPeopleAffected: string;
  rootCause: string;
  requiredSkills: string[];
  sdgGoals: { code: string; label: string }[];
  solutionAreas: string[];
}

interface CategoryAnalysis {
  rootCause: string;
  skills: string[];
  sdgs: { code: string; label: string }[];
  solutions: string[];
}

const CATEGORY_ANALYSIS: Record<string, CategoryAnalysis> = {
  Infrastructure: {
    rootCause:
      'Aging or inadequate infrastructure with insufficient maintenance funding and lack of regular inspection cycles.',
    skills: ['Civil Engineering', 'Urban Planning', 'Project Management', 'Cost Estimation'],
    sdgs: [
      { code: '9', label: 'Industry, Innovation & Infrastructure' },
      { code: '11', label: 'Sustainable Cities & Communities' },
    ],
    solutions: [
      'Infrastructure assessment and structural audit',
      'Community-funded repair initiative',
      'Preventive maintenance scheduling system',
    ],
  },
  Environment: {
    rootCause:
      'Insufficient environmental regulation enforcement and lack of community awareness about sustainable practices.',
    skills: ['Environmental Science', 'Policy Analysis', 'Data Monitoring', 'Community Outreach'],
    sdgs: [
      { code: '13', label: 'Climate Action' },
      { code: '15', label: 'Life on Land' },
      { code: '6', label: 'Clean Water & Sanitation' },
    ],
    solutions: [
      'Community monitoring and reporting program',
      'Waste reduction awareness campaign',
      'Local environmental policy advocacy',
    ],
  },
  'Public Health': {
    rootCause:
      'Limited healthcare access and insufficient public health education reaching vulnerable populations.',
    skills: ['Public Health', 'Epidemiology', 'Health Education', 'Data Analysis'],
    sdgs: [
      { code: '3', label: 'Good Health & Well-being' },
      { code: '10', label: 'Reduced Inequalities' },
    ],
    solutions: [
      'Mobile health clinic deployment',
      'Community health worker training program',
      'Preventive care awareness campaign',
    ],
  },
  Education: {
    rootCause:
      'Underfunded education system with inequitable resource distribution and outdated infrastructure.',
    skills: ['Education Policy', 'Curriculum Design', 'Educational Technology', 'Community Organizing'],
    sdgs: [
      { code: '4', label: 'Quality Education' },
      { code: '10', label: 'Reduced Inequalities' },
    ],
    solutions: [
      'After-school tutoring program',
      'Digital literacy workshop series',
      'Teacher recruitment and retention initiative',
    ],
  },
  'Community Safety': {
    rootCause:
      'Inadequate safety infrastructure and insufficient community-police engagement programs.',
    skills: ['Criminology', 'Urban Design', 'Emergency Management', 'Community Mediation'],
    sdgs: [
      { code: '16', label: 'Peace, Justice & Strong Institutions' },
      { code: '11', label: 'Sustainable Cities & Communities' },
    ],
    solutions: [
      'Neighborhood watch program setup',
      'Street lighting improvement project',
      'Community safety audit and action plan',
    ],
  },
  'Social Services': {
    rootCause:
      'Systemic gaps in social safety nets and limited access to support services for vulnerable populations.',
    skills: ['Social Work', 'Public Policy', 'Community Development', 'Resource Coordination'],
    sdgs: [
      { code: '1', label: 'No Poverty' },
      { code: '8', label: 'Decent Work & Economic Growth' },
      { code: '10', label: 'Reduced Inequalities' },
    ],
    solutions: [
      'Community resource center establishment',
      'Job skills training program',
      'Housing assistance initiative',
    ],
  },
};

const URGENCY_MAP: Record<Severity, string> = {
  Low: 'Low — Address within 3-6 months',
  Medium: 'Moderate — Address within 1-3 months',
  High: 'High — Address within 2-4 weeks',
  Critical: 'Critical — Address within 24-48 hours',
};

export function generateMockAnalysis(data: ProblemFormData): AIAnalysis {
  const base = CATEGORY_ANALYSIS[data.category] ?? {
    rootCause:
      'Multi-factor community challenge requiring structured assessment and collaborative intervention.',
    skills: ['Project Management', 'Community Outreach', 'Data Analysis'],
    sdgs: [{ code: '11', label: 'Sustainable Cities & Communities' }],
    solutions: [
      'Community needs assessment',
      'Stakeholder engagement program',
      'Phased intervention plan',
    ],
  };

  return {
    category: data.category,
    subcategory: data.subcategory,
    severity: data.severity,
    urgency: data.severity ? URGENCY_MAP[data.severity as Severity] : 'Moderate — Address within 1-3 months',
    estimatedPeopleAffected: data.peopleAffected
      ? `~${Number(data.peopleAffected).toLocaleString()} people`
      : 'Estimation pending',
    rootCause: base.rootCause,
    requiredSkills: base.skills,
    sdgGoals: base.sdgs,
    solutionAreas: base.solutions,
  };
}
