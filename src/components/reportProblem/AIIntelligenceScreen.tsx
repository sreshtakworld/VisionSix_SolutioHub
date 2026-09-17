import {
  BrainCircuit,
  Tag,
  Layers,
  AlertTriangle,
  Clock,
  Users,
  Search,
  Wrench,
  Target,
  Home,
  ClipboardList,
  Sparkles,
  ShieldAlert,
} from 'lucide-react';
import Button from '../Button';
import {
  SEVERITY_STYLES,
  type ProblemFormData,
  type Severity,
  type ReportProblemPageProps,
} from '../../reportProblemTypes';
import { generateMockAnalysis, type AIAnalysis } from '../../mockAnalysis';

interface AIIntelligenceScreenProps {
  data: ProblemFormData;
  onNavigate: ReportProblemPageProps['onNavigate'];
  onReportAnother: () => void;
}

interface InfoRowProps {
  icon: typeof Tag;
  label: string;
  children: React.ReactNode;
}

function InfoRow({ icon: Icon, label, children }: InfoRowProps) {
  return (
    <div className="flex items-start gap-3 rounded-xl border border-ink-200/70 bg-ink-50/50 p-4">
      <span className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-lg bg-brand-50 ring-1 ring-brand-100">
        <Icon className="h-4.5 w-4.5 text-brand-600" strokeWidth={2} />
      </span>
      <div className="min-w-0 flex-1">
        <p className="text-xs font-semibold uppercase tracking-wide text-ink-400">
          {label}
        </p>
        <div className="mt-1">{children}</div>
      </div>
    </div>
  );
}

export default function AIIntelligenceScreen({
  data,
  onNavigate,
  onReportAnother,
}: AIIntelligenceScreenProps) {
  const analysis: AIAnalysis = generateMockAnalysis(data);

  return (
    <section className="relative overflow-hidden bg-ink-50 pt-28 pb-20 sm:pt-32 sm:pb-28">
      <div className="pointer-events-none absolute inset-0 bg-grid opacity-40" />
      <div className="pointer-events-none absolute -top-24 right-0 h-72 w-72 rounded-full bg-brand-200/20 blur-3xl" />
      <div className="pointer-events-none absolute top-40 -left-32 h-72 w-72 rounded-full bg-accent-200/15 blur-3xl" />

      <div className="relative mx-auto max-w-4xl px-5 sm:px-8">
        {/* Header */}
        <div className="mb-8 text-center">
          <div className="mx-auto mb-5 flex h-16 w-16 items-center justify-center rounded-2xl bg-gradient-to-br from-brand-500 to-brand-700 shadow-lg shadow-brand-600/25 animate-fade-up">
            <BrainCircuit className="h-8 w-8 text-white" strokeWidth={2} />
          </div>
          <span className="text-sm font-semibold uppercase tracking-wider text-brand-600 animate-fade-up" style={{ animationDelay: '0.05s', opacity: 0 }}>
            Problem Intelligence
          </span>
          <h1 className="mt-2 text-balance text-3xl font-extrabold tracking-tight text-ink-900 sm:text-4xl animate-fade-up" style={{ animationDelay: '0.1s', opacity: 0 }}>
            AI Problem Intelligence
          </h1>
          <p className="mt-3 text-pretty text-base text-ink-500 animate-fade-up" style={{ animationDelay: '0.15s', opacity: 0 }}>
            Automated preliminary analysis of your submitted community problem.
          </p>
        </div>

        {/* AI badge + disclaimer */}
        <div className="mb-6 flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-between animate-fade-up" style={{ animationDelay: '0.2s', opacity: 0 }}>
          <div className="inline-flex items-center gap-2 rounded-full border border-brand-200 bg-brand-50 px-4 py-1.5 text-xs font-semibold text-brand-700">
            <Sparkles className="h-3.5 w-3.5" />
            AI-generated preliminary analysis
          </div>
        </div>

        {/* Problem title card */}
        <div className="mb-6 rounded-2xl border border-ink-200/70 bg-white p-5 shadow-sm animate-fade-up" style={{ animationDelay: '0.25s', opacity: 0 }}>
          <div className="flex items-start gap-3">
            <span className="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-xl bg-ink-100">
              <ClipboardList className="h-5 w-5 text-ink-600" strokeWidth={2} />
            </span>
            <div>
              <p className="text-xs font-semibold uppercase tracking-wide text-ink-400">
                Submitted Problem
              </p>
              <h2 className="mt-0.5 text-lg font-bold text-ink-900">{data.title}</h2>
              <p className="mt-1 text-sm leading-relaxed text-ink-500 line-clamp-2">
                {data.description}
              </p>
            </div>
          </div>
        </div>

        {/* Analysis card */}
        <div className="rounded-3xl border border-ink-200/70 bg-white p-6 shadow-sm sm:p-8 animate-fade-up" style={{ animationDelay: '0.3s', opacity: 0 }}>
          {/* Section heading */}
          <div className="mb-6 flex items-center gap-2">
            <Target className="h-5 w-5 text-brand-600" strokeWidth={2} />
            <h3 className="text-lg font-bold text-ink-900">Problem Intelligence</h3>
          </div>

          {/* Core info grid */}
          <div className="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <InfoRow icon={Tag} label="Problem Category">
              <p className="text-sm font-semibold text-ink-800">{analysis.category}</p>
            </InfoRow>

            <InfoRow icon={Layers} label="Subcategory">
              <p className="text-sm font-semibold text-ink-800">{analysis.subcategory}</p>
            </InfoRow>

            <InfoRow icon={AlertTriangle} label="Severity">
              {analysis.severity ? (
                <span className={`inline-flex rounded-full border px-3 py-0.5 text-xs font-semibold ${SEVERITY_STYLES[analysis.severity as Severity]}`}>
                  {analysis.severity}
                </span>
              ) : (
                <p className="text-sm text-ink-600">Not specified</p>
              )}
            </InfoRow>

            <InfoRow icon={Clock} label="Urgency">
              <p className="text-sm font-semibold text-ink-800">{analysis.urgency}</p>
            </InfoRow>

            <InfoRow icon={Users} label="Estimated People Affected">
              <p className="text-sm font-semibold text-ink-800">{analysis.estimatedPeopleAffected}</p>
            </InfoRow>

            <InfoRow icon={Search} label="Likely Root Cause">
              <p className="text-sm leading-relaxed text-ink-700">{analysis.rootCause}</p>
            </InfoRow>
          </div>

          {/* Required Skills */}
          <div className="mt-6 rounded-xl border border-ink-200/70 bg-ink-50/50 p-4">
            <div className="flex items-center gap-2">
              <Wrench className="h-4 w-4 text-brand-600" strokeWidth={2} />
              <p className="text-xs font-semibold uppercase tracking-wide text-ink-400">
                Required Skills / Expertise
              </p>
            </div>
            <div className="mt-3 flex flex-wrap gap-2">
              {analysis.requiredSkills.map((skill) => (
                <span
                  key={skill}
                  className="inline-flex items-center rounded-lg border border-brand-200 bg-brand-50 px-3 py-1.5 text-xs font-semibold text-brand-700"
                >
                  {skill}
                </span>
              ))}
            </div>
          </div>

          {/* SDG Goals */}
          <div className="mt-4 rounded-xl border border-ink-200/70 bg-ink-50/50 p-4">
            <div className="flex items-center gap-2">
              <Target className="h-4 w-4 text-accent-600" strokeWidth={2} />
              <p className="text-xs font-semibold uppercase tracking-wide text-ink-400">
                Relevant SDG Goals
              </p>
            </div>
            <div className="mt-3 flex flex-wrap gap-2">
              {analysis.sdgGoals.map((sdg) => (
                <span
                  key={sdg.code}
                  className="inline-flex items-center gap-1.5 rounded-lg border border-accent-200 bg-accent-50 px-3 py-1.5 text-xs font-semibold text-accent-700"
                >
                  <span className="flex h-5 w-5 items-center justify-center rounded-full bg-accent-600 text-[10px] font-bold text-white">
                    {sdg.code}
                  </span>
                  {sdg.label}
                </span>
              ))}
            </div>
          </div>

          {/* Suggested Solution Areas */}
          <div className="mt-4 rounded-xl border border-ink-200/70 bg-ink-50/50 p-4">
            <div className="flex items-center gap-2">
              <Sparkles className="h-4 w-4 text-brand-600" strokeWidth={2} />
              <p className="text-xs font-semibold uppercase tracking-wide text-ink-400">
                Suggested Solution Areas
              </p>
            </div>
            <ul className="mt-3 space-y-2">
              {analysis.solutionAreas.map((solution, i) => (
                <li key={solution} className="flex items-start gap-2.5">
                  <span className="mt-0.5 flex h-5 w-5 flex-shrink-0 items-center justify-center rounded-full bg-brand-100 text-[10px] font-bold text-brand-700">
                    {i + 1}
                  </span>
                  <span className="text-sm text-ink-700">{solution}</span>
                </li>
              ))}
            </ul>
          </div>
        </div>

        {/* Disclaimer */}
        <div className="mt-6 flex items-start gap-3 rounded-2xl border border-amber-200 bg-amber-50/60 p-4 animate-fade-up" style={{ animationDelay: '0.35s', opacity: 0 }}>
          <ShieldAlert className="h-5 w-5 flex-shrink-0 text-amber-600" strokeWidth={2} />
          <p className="text-sm leading-relaxed text-ink-600">
            This analysis is for prioritization and collaboration support and
            should be reviewed by humans.
          </p>
        </div>

        {/* Actions */}
        <div className="mt-8 flex flex-col items-center justify-center gap-3 sm:flex-row animate-fade-up" style={{ animationDelay: '0.4s', opacity: 0 }}>
          <Button size="lg" onClick={() => onNavigate('home')}>
            <Home className="h-5 w-5" />
            Back to Home
          </Button>
          <Button size="lg" variant="secondary" onClick={onReportAnother}>
            <ClipboardList className="h-5 w-5 text-brand-600" />
            Report Another Problem
          </Button>
        </div>
      </div>
    </section>
  );
}
