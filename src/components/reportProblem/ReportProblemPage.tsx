import { useState } from 'react';
import {
  ArrowLeft,
  ArrowRight,
  Check,
  ClipboardList,
  MapPin,
  AlertTriangle,
  FileCheck,
  Sparkles,
  Home,
  BrainCircuit,
} from 'lucide-react';
import Button from '../Button';
import StepProblem from './StepProblem';
import StepLocation from './StepLocation';
import StepUrgency from './StepUrgency';
import StepReview from './StepReview';
import AIIntelligenceScreen from './AIIntelligenceScreen';
import {
  STEPS,
  INITIAL_FORM_DATA,
  type ProblemFormData,
  type FormErrors,
  type StepId,
  type ReportProblemPageProps,
} from '../../reportProblemTypes';

const STEP_ICONS = [ClipboardList, MapPin, AlertTriangle, FileCheck];

function validateStep(step: StepId, data: ProblemFormData): FormErrors {
  const errors: FormErrors = {};

  if (step === 1) {
    if (!data.title.trim()) errors.title = 'Please enter a problem title';
    if (!data.description.trim())
      errors.description = 'Please describe the problem';
    if (!data.category) errors.category = 'Please select a category';
    if (!data.subcategory) errors.subcategory = 'Please select a subcategory';
  }

  if (step === 2) {
    if (!data.city.trim()) errors.city = 'Please enter a city';
    if (!data.state.trim()) errors.state = 'Please enter a state';
    if (!data.area.trim()) errors.area = 'Please enter an area or locality';
    if (!data.peopleAffected.trim())
      errors.peopleAffected = 'Please estimate the number of people affected';
  }

  if (step === 3) {
    if (!data.severity) errors.severity = 'Please select a severity level';
    if (!data.frequency) errors.frequency = 'Please select a frequency';
    if (!data.affectedGroup.trim())
      errors.affectedGroup = 'Please describe who is mainly affected';
  }

  return errors;
}

export default function ReportProblemPage({ onNavigate }: ReportProblemPageProps) {
  const [currentStep, setCurrentStep] = useState<StepId>(1);
  const [data, setData] = useState<ProblemFormData>(INITIAL_FORM_DATA);
  const [errors, setErrors] = useState<FormErrors>({});
  const [submitting, setSubmitting] = useState(false);
  const [submitted, setSubmitted] = useState(false);
  const [showAnalysis, setShowAnalysis] = useState(false);

  const update = (field: keyof ProblemFormData, value: string) => {
    setData((prev) => ({ ...prev, [field]: value }));
    if (errors[field]) {
      setErrors((prev) => {
        const next = { ...prev };
        delete next[field];
        return next;
      });
    }
  };

  const goNext = () => {
    const stepErrors = validateStep(currentStep, data);
    if (Object.keys(stepErrors).length > 0) {
      setErrors(stepErrors);
      return;
    }
    setErrors({});
    if (currentStep < 4) setCurrentStep((currentStep + 1) as StepId);
  };

  const goBack = () => {
    setErrors({});
    if (currentStep > 1) setCurrentStep((currentStep - 1) as StepId);
  };

  const goToStep = (step: StepId) => {
    setErrors({});
    setCurrentStep(step);
  };

  const handleSubmit = () => {
    const allErrors: FormErrors = {};
    (['title', 'description', 'category', 'subcategory', 'city', 'state', 'area', 'peopleAffected', 'severity', 'frequency', 'affectedGroup'] as (keyof ProblemFormData)[]).forEach(
      (field) => {
        if (!data[field] || !String(data[field]).trim()) {
          allErrors[field] = 'This field is required';
        }
      }
    );
    if (Object.keys(allErrors).length > 0) {
      setErrors(allErrors);
      setCurrentStep(1);
      return;
    }

    setSubmitting(true);
    setTimeout(() => {
      setSubmitting(false);
      setSubmitted(true);
      window.scrollTo({ top: 0, behavior: 'smooth' });
    }, 800);
  };

  const resetForm = () => {
    setData(INITIAL_FORM_DATA);
    setErrors({});
    setSubmitted(false);
    setShowAnalysis(false);
    setCurrentStep(1);
  };

  // AI Intelligence screen
  if (showAnalysis) {
    return (
      <AIIntelligenceScreen
        data={data}
        onNavigate={onNavigate}
        onReportAnother={resetForm}
      />
    );
  }

  // Success screen
  if (submitted) {
    return (
      <section className="relative overflow-hidden bg-grid pt-32 pb-24 sm:pt-40 sm:pb-32">
        <div className="pointer-events-none absolute inset-0 bg-radial-fade" />
        <div className="pointer-events-none absolute -top-24 -right-24 h-96 w-96 rounded-full bg-accent-200/30 blur-3xl animate-pulse-slow" />
        <div className="pointer-events-none absolute top-40 -left-32 h-80 w-80 rounded-full bg-brand-200/25 blur-3xl animate-pulse-slow" />

        <div className="relative mx-auto max-w-xl px-5 text-center sm:px-8">
          <div className="mx-auto mb-8 flex h-20 w-20 items-center justify-center rounded-full bg-accent-50 ring-4 ring-accent-100 animate-fade-up">
            <Check className="h-10 w-10 text-accent-600" strokeWidth={2.5} />
          </div>

          <h1 className="text-balance text-3xl font-extrabold tracking-tight text-ink-900 sm:text-4xl animate-fade-up" style={{ animationDelay: '0.1s', opacity: 0 }}>
            Problem submitted successfully
          </h1>

          <div className="mx-auto mt-6 max-w-md rounded-2xl border border-brand-200 bg-brand-50/60 p-5 animate-fade-up" style={{ animationDelay: '0.2s', opacity: 0 }}>
            <div className="flex items-start gap-3">
              <span className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-lg bg-brand-100">
                <Sparkles className="h-5 w-5 text-brand-600" strokeWidth={2} />
              </span>
              <p className="text-left text-sm leading-relaxed text-ink-700">
                SolutionHub will analyze this problem and identify suitable
                collaborators.
              </p>
            </div>
          </div>

          <div className="mt-9 flex flex-col items-center justify-center gap-3 sm:flex-row animate-fade-up" style={{ animationDelay: '0.3s', opacity: 0 }}>
            <Button size="lg" onClick={() => setShowAnalysis(true)}>
              <BrainCircuit className="h-5 w-5" />
              View AI Analysis
            </Button>
            <Button size="lg" variant="secondary" onClick={() => onNavigate('home')}>
              <Home className="h-5 w-5" />
              Back to Home
            </Button>
          </div>
        </div>
      </section>
    );
  }

  // Form
  return (
    <section className="relative overflow-hidden bg-ink-50 pt-28 pb-20 sm:pt-32 sm:pb-28">
      <div className="pointer-events-none absolute inset-0 bg-grid opacity-40" />
      <div className="pointer-events-none absolute -top-24 right-0 h-72 w-72 rounded-full bg-brand-200/20 blur-3xl" />

      <div className="relative mx-auto max-w-3xl px-5 sm:px-8">
        {/* Header */}
        <div className="mb-8 text-center">
          <span className="text-sm font-semibold uppercase tracking-wider text-brand-600">
            Citizen Report
          </span>
          <h1 className="mt-2 text-balance text-3xl font-extrabold tracking-tight text-ink-900 sm:text-4xl">
            Report a Problem
          </h1>
          <p className="mt-3 text-pretty text-base text-ink-500">
            Share a community challenge that needs a solution. It only takes a
            few minutes.
          </p>
        </div>

        {/* Stepper */}
        <div className="mb-8">
          <div className="flex items-center justify-between">
            {STEPS.map((step, i) => {
              const StepIcon = STEP_ICONS[i];
              const isComplete = currentStep > step.id;
              const isCurrent = currentStep === step.id;
              return (
                <div key={step.id} className="flex flex-1 items-center last:flex-none">
                  <div className="flex flex-col items-center gap-2">
                    <div
                      className={`flex h-10 w-10 items-center justify-center rounded-full border-2 transition-all duration-300 sm:h-12 sm:w-12 ${
                        isComplete
                          ? 'border-accent-500 bg-accent-500 text-white'
                          : isCurrent
                            ? 'border-brand-600 bg-brand-600 text-white shadow-lg shadow-brand-600/30'
                            : 'border-ink-200 bg-white text-ink-400'
                      }`}
                    >
                      {isComplete ? (
                        <Check className="h-5 w-5 sm:h-6 sm:w-6" strokeWidth={2.5} />
                      ) : (
                        <StepIcon className="h-4 w-4 sm:h-5 sm:w-5" strokeWidth={2} />
                      )}
                    </div>
                    <span
                      className={`hidden text-xs font-semibold sm:block ${
                        isCurrent || isComplete ? 'text-ink-900' : 'text-ink-400'
                      }`}
                    >
                      {step.label}
                    </span>
                  </div>
                  {i < STEPS.length - 1 && (
                    <div
                      className={`mx-2 h-0.5 flex-1 rounded-full transition-colors duration-300 ${
                        isComplete ? 'bg-accent-500' : 'bg-ink-200'
                      }`}
                    />
                  )}
                </div>
              );
            })}
          </div>
        </div>

        {/* Form card */}
        <div className="rounded-3xl border border-ink-200/70 bg-white p-6 shadow-sm sm:p-8">
          {/* Step title */}
          <div className="mb-6">
            <h2 className="text-xl font-bold text-ink-900">
              Step {currentStep}: {STEPS[currentStep - 1].label}
            </h2>
            <p className="mt-1 text-sm text-ink-500">
              {STEPS[currentStep - 1].description}
            </p>
          </div>

          {/* Step content */}
          {currentStep === 1 && (
            <StepProblem data={data} errors={errors} update={update} />
          )}
          {currentStep === 2 && (
            <StepLocation data={data} errors={errors} update={update} />
          )}
          {currentStep === 3 && (
            <StepUrgency data={data} errors={errors} update={update} />
          )}
          {currentStep === 4 && (
            <StepReview
              data={data}
              onEdit={goToStep}
              onSubmit={handleSubmit}
              submitting={submitting}
            />
          )}

          {/* Navigation buttons (hidden on review step) */}
          {currentStep < 4 && (
            <div className="mt-8 flex items-center justify-between gap-3 border-t border-ink-100 pt-6">
              <Button
                variant="ghost"
                onClick={currentStep === 1 ? () => onNavigate('home') : goBack}
              >
                <ArrowLeft className="h-4 w-4" />
                {currentStep === 1 ? 'Cancel' : 'Back'}
              </Button>
              <Button onClick={goNext}>
                Continue
                <ArrowRight className="h-4 w-4" />
              </Button>
            </div>
          )}
          {currentStep === 4 && (
            <div className="mt-8 flex items-center gap-3 border-t border-ink-100 pt-6">
              <Button variant="ghost" onClick={goBack}>
                <ArrowLeft className="h-4 w-4" />
                Back
              </Button>
            </div>
          )}
        </div>
      </div>
    </section>
  );
}
