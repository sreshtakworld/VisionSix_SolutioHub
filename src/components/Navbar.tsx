import { useEffect, useState } from 'react';
import { Menu, X, Sparkles } from 'lucide-react';
import { PAGES, type PageId } from '../navigation';

interface NavbarProps {
  currentPage: PageId;
  onNavigate: (page: PageId) => void;
}

export default function Navbar({ currentPage, onNavigate }: NavbarProps) {
  const [scrolled, setScrolled] = useState(false);
  const [mobileOpen, setMobileOpen] = useState(false);

  useEffect(() => {
    const onScroll = () => setScrolled(window.scrollY > 8);
    onScroll();
    window.addEventListener('scroll', onScroll, { passive: true });
    return () => window.removeEventListener('scroll', onScroll);
  }, []);

  const handleNavigate = (page: PageId) => {
    onNavigate(page);
    setMobileOpen(false);
  };

  return (
    <header
      className={`fixed top-0 left-0 right-0 z-50 transition-all duration-300 ${
        scrolled
          ? 'bg-white/85 backdrop-blur-lg border-b border-ink-200/60 shadow-sm'
          : 'bg-transparent'
      }`}
    >
      <nav className="mx-auto flex max-w-7xl items-center justify-between px-5 py-3.5 sm:px-8">
        {/* Logo */}
        <button
          onClick={() => handleNavigate('home')}
          className="flex items-center gap-2.5 group"
        >
          <span className="flex h-9 w-9 items-center justify-center rounded-xl bg-gradient-to-br from-brand-500 to-brand-700 shadow-md shadow-brand-600/25 transition-transform group-hover:scale-105">
            <Sparkles className="h-5 w-5 text-white" strokeWidth={2.5} />
          </span>
          <span className="text-lg font-extrabold tracking-tight text-ink-900">
            Solution<span className="text-brand-600">Hub</span>
          </span>
        </button>

        {/* Desktop nav */}
        <ul className="hidden items-center gap-1 md:flex">
          {PAGES.map((link) => (
            <li key={link.id}>
              <button
                onClick={() => handleNavigate(link.id)}
                className={`rounded-full px-4 py-2 text-sm font-medium transition-colors ${
                  currentPage === link.id
                    ? 'bg-brand-50 text-brand-700'
                    : 'text-ink-600 hover:bg-ink-100 hover:text-ink-900'
                }`}
              >
                {link.label}
              </button>
            </li>
          ))}
        </ul>

        {/* Desktop login */}
        <div className="hidden md:block">
          <button
            onClick={() => handleNavigate('login')}
            className="inline-flex items-center rounded-full border border-brand-200 bg-white px-5 py-2 text-sm font-semibold text-brand-700 shadow-sm transition-all hover:bg-brand-50 hover:shadow-md"
          >
            Login
          </button>
        </div>

        {/* Mobile toggle */}
        <button
          onClick={() => setMobileOpen((v) => !v)}
          className="flex h-10 w-10 items-center justify-center rounded-lg text-ink-700 transition-colors hover:bg-ink-100 md:hidden"
          aria-label="Toggle menu"
          aria-expanded={mobileOpen}
        >
          {mobileOpen ? <X className="h-5 w-5" /> : <Menu className="h-5 w-5" />}
        </button>
      </nav>

      {/* Mobile menu */}
      <div
        className={`md:hidden overflow-hidden transition-all duration-300 ease-out ${
          mobileOpen ? 'max-h-96 opacity-100' : 'max-h-0 opacity-0'
        }`}
      >
        <div className="mx-4 mb-4 rounded-2xl border border-ink-200/70 bg-white/95 p-4 shadow-lg backdrop-blur-lg">
          <ul className="flex flex-col gap-1">
            {PAGES.map((link) => (
              <li key={link.id}>
                <button
                  onClick={() => handleNavigate(link.id)}
                  className={`block w-full rounded-xl px-4 py-3 text-left text-sm font-medium transition-colors ${
                    currentPage === link.id
                      ? 'bg-brand-50 text-brand-700'
                      : 'text-ink-700 hover:bg-brand-50 hover:text-brand-700'
                  }`}
                >
                  {link.label}
                </button>
              </li>
            ))}
          </ul>
          <button
            onClick={() => handleNavigate('login')}
            className="mt-3 block w-full rounded-xl bg-brand-600 px-4 py-3 text-center text-sm font-semibold text-white shadow-md transition-colors hover:bg-brand-700"
          >
            Login
          </button>
        </div>
      </div>
    </header>
  );
}
