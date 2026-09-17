import { Sparkles, Heart } from 'lucide-react';
import type { PageId } from '../navigation';

interface FooterProps {
  onNavigate: (page: PageId) => void;
}

const FOOTER_LINKS: { heading: string; items: { label: string; page: PageId }[] }[] = [
  {
    heading: 'Platform',
    items: [
      { label: 'Home', page: 'home' },
      { label: 'How It Works', page: 'how-it-works' },
      { label: 'Challenges', page: 'challenges' },
      { label: 'Impact', page: 'impact' },
    ],
  },
  {
    heading: 'Company',
    items: [
      { label: 'About', page: 'about' },
      { label: 'Careers', page: 'about' },
      { label: 'Blog', page: 'about' },
      { label: 'Contact', page: 'about' },
    ],
  },
  {
    heading: 'Resources',
    items: [
      { label: 'Documentation', page: 'about' },
      { label: 'Community', page: 'about' },
      { label: 'Support', page: 'about' },
      { label: 'API', page: 'about' },
    ],
  },
];

export default function Footer({ onNavigate }: FooterProps) {
  return (
    <footer className="border-t border-ink-200 bg-white">
      <div className="mx-auto max-w-7xl px-5 py-14 sm:px-8">
        <div className="grid grid-cols-2 gap-8 md:grid-cols-4">
          {/* Brand */}
          <div className="col-span-2 md:col-span-1">
            <button
              onClick={() => onNavigate('home')}
              className="flex items-center gap-2.5"
            >
              <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-brand-500 to-brand-700 shadow-md shadow-brand-600/25">
                <Sparkles className="h-5 w-5 text-white" strokeWidth={2.5} />
              </span>
              <span className="text-lg font-extrabold tracking-tight text-ink-900">
                Solution<span className="text-brand-600">Hub</span>
              </span>
            </button>
            <p className="mt-3 text-sm leading-relaxed text-ink-500">
              From Community Problems to Collaborative Solutions.
            </p>
          </div>

          {/* Link columns */}
          {FOOTER_LINKS.map((col) => (
            <div key={col.heading}>
              <h4 className="text-xs font-bold uppercase tracking-wider text-ink-400">
                {col.heading}
              </h4>
              <ul className="mt-3 space-y-2">
                {col.items.map((item) => (
                  <li key={item.label}>
                    <button
                      onClick={() => onNavigate(item.page)}
                      className="text-sm text-ink-500 transition-colors hover:text-brand-600"
                    >
                      {item.label}
                    </button>
                  </li>
                ))}
              </ul>
            </div>
          ))}
        </div>

        <div className="mt-12 flex flex-col items-center justify-between gap-3 border-t border-ink-200 pt-6 sm:flex-row">
          <p className="text-xs text-ink-400">
            &copy; {new Date().getFullYear()} SolutionHub. All rights reserved.
          </p>
          <p className="flex items-center gap-1.5 text-xs text-ink-400">
            Built with <Heart className="h-3.5 w-3.5 text-accent-500" fill="currentColor" /> for communities everywhere
          </p>
        </div>
      </div>
    </footer>
  );
}
