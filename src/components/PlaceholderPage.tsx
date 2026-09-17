import { ArrowLeft, Construction } from 'lucide-react';
import Button from './Button';
import type { PageId } from '../navigation';

interface PlaceholderPageProps {
  pageId: PageId;
  title: string;
  description: string;
  onNavigate: (page: PageId) => void;
}

export default function PlaceholderPage({
  title,
  description,
  onNavigate,
}: PlaceholderPageProps) {
  return (
    <section className="relative overflow-hidden bg-grid pt-32 pb-24 sm:pt-40 sm:pb-32">
      <div className="pointer-events-none absolute inset-0 bg-radial-fade" />
      <div className="pointer-events-none absolute -top-24 -right-24 h-96 w-96 rounded-full bg-brand-200/30 blur-3xl animate-pulse-slow" />

      <div className="relative mx-auto max-w-2xl px-5 text-center sm:px-8">
        <div className="mx-auto mb-8 flex h-20 w-20 items-center justify-center rounded-2xl bg-brand-50 ring-1 ring-brand-200">
          <Construction className="h-10 w-10 text-brand-600" strokeWidth={1.8} />
        </div>

        <h1 className="text-balance text-3xl font-extrabold tracking-tight text-ink-900 sm:text-4xl">
          {title}
        </h1>

        <p className="mx-auto mt-5 max-w-lg text-pretty text-lg leading-relaxed text-ink-500">
          {description}
        </p>

        <div className="mt-9 flex justify-center">
          <Button
            variant="secondary"
            size="lg"
            onClick={() => onNavigate('home')}
          >
            <ArrowLeft className="h-5 w-5 text-brand-600" />
            Back to Home
          </Button>
        </div>
      </div>
    </section>
  );
}
