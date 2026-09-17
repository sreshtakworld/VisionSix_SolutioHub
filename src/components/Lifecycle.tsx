import {
  Users,
  BrainCircuit,
  GraduationCap,
  Factory,
  FolderGit2,
  TrendingUp,
  ArrowRight,
} from 'lucide-react';

const STEPS = [
  {
    icon: Users,
    title: 'Community Problem',
    desc: 'Local residents and organizations report real challenges that matter to them.',
    color: 'text-brand-600',
    bg: 'bg-brand-50',
    ring: 'ring-brand-200',
  },
  {
    icon: BrainCircuit,
    title: 'AI Analysis',
    desc: 'AI categorizes and structures the problem to match it with the right expertise.',
    color: 'text-accent-600',
    bg: 'bg-accent-50',
    ring: 'ring-accent-200',
  },
  {
    icon: GraduationCap,
    title: 'University',
    desc: 'Faculty and students adopt the challenge as coursework or research.',
    color: 'text-brand-600',
    bg: 'bg-brand-50',
    ring: 'ring-brand-200',
  },
  {
    icon: Factory,
    title: 'Industry',
    desc: 'Industry partners provide mentorship, resources, and real-world context.',
    color: 'text-accent-600',
    bg: 'bg-accent-50',
    ring: 'ring-accent-200',
  },
  {
    icon: FolderGit2,
    title: 'Project',
    desc: 'A structured project is scoped, built, and delivered as a team effort.',
    color: 'text-brand-600',
    bg: 'bg-brand-50',
    ring: 'ring-brand-200',
  },
  {
    icon: TrendingUp,
    title: 'Impact',
    desc: 'Measurable outcomes are tracked and shared back with the community.',
    color: 'text-accent-600',
    bg: 'bg-accent-50',
    ring: 'ring-accent-200',
  },
];

export default function Lifecycle() {
  return (
    <section
      id="how-it-works"
      className="relative bg-ink-50 py-20 sm:py-28"
    >
      <div className="mx-auto max-w-7xl px-5 sm:px-8">
        {/* Section header */}
        <div className="mx-auto max-w-2xl text-center">
          <span className="text-sm font-semibold uppercase tracking-wider text-brand-600">
            How It Works
          </span>
          <h2 className="mt-3 text-balance text-3xl font-extrabold tracking-tight text-ink-900 sm:text-4xl">
            The solution lifecycle
          </h2>
          <p className="mt-4 text-pretty text-lg text-ink-500">
            Every problem moves through a clear, transparent pipeline — from a
            community voice to a measurable outcome.
          </p>
        </div>

        {/* Flow */}
        <div className="mt-14 grid grid-cols-1 gap-5 sm:grid-cols-2 lg:grid-cols-3">
          {STEPS.map((step, i) => {
            const Icon = step.icon;
            return (
              <div
                key={step.title}
                className="group relative rounded-2xl border border-ink-200/70 bg-white p-6 shadow-sm transition-all duration-300 hover:-translate-y-1 hover:shadow-xl hover:shadow-ink-200/40"
              >
                {/* Step number */}
                <span className="absolute right-5 top-5 text-5xl font-extrabold text-ink-100 transition-colors group-hover:text-brand-100">
                  {String(i + 1).padStart(2, '0')}
                </span>

                {/* Icon */}
                <div
                  className={`relative flex h-12 w-12 items-center justify-center rounded-xl ${step.bg} ring-1 ${step.ring} transition-transform duration-300 group-hover:scale-110`}
                >
                  <Icon className={`h-6 w-6 ${step.color}`} strokeWidth={2} />
                </div>

                <h3 className="mt-5 text-lg font-bold text-ink-900">
                  {step.title}
                </h3>
                <p className="mt-2 text-sm leading-relaxed text-ink-500">
                  {step.desc}
                </p>

                {/* Connector arrow (hidden on last item) */}
                {i < STEPS.length - 1 && (
                  <div className="mt-5 hidden items-center gap-1 text-ink-300 lg:flex">
                    <span className="text-xs font-medium text-ink-400">
                      Next
                    </span>
                    <ArrowRight className="h-4 w-4 transition-transform group-hover:translate-x-1 group-hover:text-brand-400" />
                  </div>
                )}
              </div>
            );
          })}
        </div>
      </div>
    </section>
  );
}
