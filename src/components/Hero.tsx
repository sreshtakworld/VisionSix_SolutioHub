import { ArrowRight, Compass } from 'lucide-react';
import Button from './Button';
import type { PageId } from '../navigation';

interface HeroProps {
  onNavigate: (page: PageId) => void;
}

export default function Hero({ onNavigate }: HeroProps) {
  return (
    <section
      id="home"
      className="relative overflow-hidden bg-grid pt-32 pb-20 sm:pt-40 sm:pb-28"
    >
      {/* Background glows */}
      <div className="pointer-events-none absolute inset-0 bg-radial-fade" />
      <div className="pointer-events-none absolute -top-24 -right-24 h-96 w-96 rounded-full bg-brand-200/30 blur-3xl animate-pulse-slow" />
      <div className="pointer-events-none absolute top-40 -left-32 h-80 w-80 rounded-full bg-accent-200/25 blur-3xl animate-pulse-slow" />

      <div className="relative mx-auto max-w-5xl px-5 text-center sm:px-8">
        {/* Badge */}
        <div className="mb-7 inline-flex items-center gap-2 rounded-full border border-brand-200 bg-brand-50/80 px-4 py-1.5 text-xs font-semibold text-brand-700 backdrop-blur-sm animate-fade-in">
          <span className="relative flex h-2 w-2">
            <span className="absolute inline-flex h-full w-full animate-ping rounded-full bg-accent-400 opacity-75" />
            <span className="relative inline-flex h-2 w-2 rounded-full bg-accent-500" />
          </span>
          A new civic-tech platform — now in early access
        </div>

        {/* Heading */}
        <h1
          className="text-balance text-4xl font-extrabold leading-[1.1] tracking-tight text-ink-900 sm:text-5xl md:text-6xl animate-fade-up"
          style={{ animationDelay: '0.05s', opacity: 0 }}
        >
          From Community Problems to{' '}
          <span className="bg-gradient-to-r from-brand-600 via-brand-500 to-accent-600 bg-clip-text text-transparent">
            Collaborative Solutions.
          </span>
        </h1>

        {/* Description */}
        <p
          className="mx-auto mt-6 max-w-2xl text-pretty text-lg leading-relaxed text-ink-500 sm:text-xl animate-fade-up"
          style={{ animationDelay: '0.15s', opacity: 0 }}
        >
          SolutionHub connects real community problems with universities,
          students, faculty, and industry partners — turning local challenges
          into measurable, real-world solutions.
        </p>

        {/* CTAs */}
        <div
          className="mt-9 flex flex-col items-center justify-center gap-3 sm:flex-row animate-fade-up"
          style={{ animationDelay: '0.25s', opacity: 0 }}
        >
          <Button
            size="lg"
            className="w-full sm:w-auto"
            onClick={() => onNavigate('report-problem')}
          >
            Report a Problem
            <ArrowRight className="h-5 w-5" />
          </Button>
          <Button
            size="lg"
            variant="secondary"
            className="w-full sm:w-auto"
            onClick={() => onNavigate('explore-challenges')}
          >
            <Compass className="h-5 w-5 text-brand-600" />
            Explore Challenges
          </Button>
        </div>

        {/* Trust line */}
        <p
          className="mt-8 text-sm text-ink-400 animate-fade-in"
          style={{ animationDelay: '0.4s', opacity: 0 }}
        >
          Trusted by communities, universities, and industry innovators
        </p>
      </div>
    </section>
  );
}
