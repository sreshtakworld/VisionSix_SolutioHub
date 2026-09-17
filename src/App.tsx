import { useCallback, useEffect, useState } from 'react';
import Navbar from './components/Navbar';
import Hero from './components/Hero';
import Lifecycle from './components/Lifecycle';
import Footer from './components/Footer';
import PlaceholderPage from './components/PlaceholderPage';
import ReportProblemPage from './components/reportProblem/ReportProblemPage';
import { type PageId } from './navigation';

const PLACEHOLDER_PAGES: Record<
  PageId,
  { title: string; description: string }
> = {
  challenges: {
    title: 'Challenges',
    description:
      'Browse open community challenges waiting for university and industry partners to adopt. This page is coming soon.',
  },
  impact: {
    title: 'Impact',
    description:
      'See the measurable outcomes SolutionHub has delivered for communities. This page is coming soon.',
  },
  about: {
    title: 'About SolutionHub',
    description:
      'Learn about our mission to connect community problems with collaborative solutions. This page is coming soon.',
  },
  login: {
    title: 'Login',
    description:
      'Sign in to your SolutionHub account to report problems and track projects. This page is coming soon.',
  },
  'report-problem': {
    title: 'Report a Problem',
    description:
      'Share a community challenge that needs a solution. This page is coming soon.',
  },
  'explore-challenges': {
    title: 'Explore Challenges',
    description:
      'Discover open challenges looking for collaborators. This page is coming soon.',
  },
  home: { title: '', description: '' },
  'how-it-works': { title: '', description: '' },
};

function App() {
  const [currentPage, setCurrentPage] = useState<PageId>('home');

  const handleNavigate = useCallback((page: PageId) => {
    setCurrentPage(page);
    window.scrollTo({ top: 0, behavior: 'smooth' });
  }, []);

  useEffect(() => {
    window.scrollTo({ top: 0 });
  }, []);

  const renderPage = () => {
    switch (currentPage) {
      case 'home':
        return (
          <>
            <Hero onNavigate={handleNavigate} />
            <Lifecycle />
          </>
        );
      case 'how-it-works':
        return <Lifecycle />;
      case 'report-problem':
        return <ReportProblemPage onNavigate={handleNavigate} />;
      default: {
        const info = PLACEHOLDER_PAGES[currentPage];
        return (
          <PlaceholderPage
            pageId={currentPage}
            title={info.title}
            description={info.description}
            onNavigate={handleNavigate}
          />
        );
      }
    }
  };

  return (
    <div className="min-h-screen bg-white">
      <Navbar currentPage={currentPage} onNavigate={handleNavigate} />
      <main>{renderPage()}</main>
      <Footer onNavigate={handleNavigate} />
    </div>
  );
}

export default App;
