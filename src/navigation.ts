export type PageId =
  | 'home'
  | 'how-it-works'
  | 'challenges'
  | 'impact'
  | 'about'
  | 'login'
  | 'report-problem'
  | 'explore-challenges';

export const PAGES: { id: PageId; label: string }[] = [
  { id: 'home', label: 'Home' },
  { id: 'how-it-works', label: 'How It Works' },
  { id: 'challenges', label: 'Challenges' },
  { id: 'impact', label: 'Impact' },
  { id: 'about', label: 'About' },
];
