import { Pencil } from 'lucide-react';
import Button from '../Button';
import {
  SEVERITY_STYLES,
  type ProblemFormData,
  type Severity,
  type StepId,
} from '../../reportProblemTypes';

interface StepReviewProps {
  data: ProblemFormData;
  onEdit: (step: StepId) => void;
  onSubmit: () => void;
  submitting: boolean;
}

interface ReviewItemProps {
  label: string;
  value: string;
}

function ReviewItem({ label, value }: ReviewItemProps) {
  return (
    <div className="flex flex-col gap-0.5">
      <dt className="text-xs font-semibold uppercase tracking-wide text-ink-400">
        {label}
      </dt>
      <dd className="text-sm text-ink-800">{value || '—'}</dd>
    </div>
  );
}

export default function StepReview({
  data,
  onEdit,
  onSubmit,
  submitting,
}: StepReviewProps) {
  return (
    <div className="space-y-6">
      {/* Step 1 summary */}
      <div className="rounded-2xl border border-ink-200 bg-ink-50 p-5">
        <div className="flex items-center justify-between">
          <h3 className="text-sm font-bold uppercase tracking-wide text-ink-500">
            Problem
          </h3>
          <button
            onClick={() => onEdit(1)}
            className="inline-flex items-center gap-1.5 rounded-lg px-2.5 py-1 text-xs font-semibold text-brand-600 transition-colors hover:bg-brand-50"
          >
            <Pencil className="h-3.5 w-3.5" />
            Edit
          </button>
        </div>
        <dl className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div className="sm:col-span-2">
            <ReviewItem label="Title" value={data.title} />
          </div>
          <div className="sm:col-span-2">
            <ReviewItem label="Description" value={data.description} />
          </div>
          <ReviewItem label="Category" value={data.category} />
          <ReviewItem label="Subcategory" value={data.subcategory} />
        </dl>
      </div>

      {/* Step 2 summary */}
      <div className="rounded-2xl border border-ink-200 bg-ink-50 p-5">
        <div className="flex items-center justify-between">
          <h3 className="text-sm font-bold uppercase tracking-wide text-ink-500">
            Location &amp; People
          </h3>
          <button
            onClick={() => onEdit(2)}
            className="inline-flex items-center gap-1.5 rounded-lg px-2.5 py-1 text-xs font-semibold text-brand-600 transition-colors hover:bg-brand-50"
          >
            <Pencil className="h-3.5 w-3.5" />
            Edit
          </button>
        </div>
        <dl className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
          <ReviewItem label="City" value={data.city} />
          <ReviewItem label="State" value={data.state} />
          <ReviewItem label="Area / locality" value={data.area} />
          <ReviewItem
            label="People affected"
            value={data.peopleAffected ? `~${data.peopleAffected}` : ''}
          />
        </dl>
      </div>

      {/* Step 3 summary */}
      <div className="rounded-2xl border border-ink-200 bg-ink-50 p-5">
        <div className="flex items-center justify-between">
          <h3 className="text-sm font-bold uppercase tracking-wide text-ink-500">
            Urgency
          </h3>
          <button
            onClick={() => onEdit(3)}
            className="inline-flex items-center gap-1.5 rounded-lg px-2.5 py-1 text-xs font-semibold text-brand-600 transition-colors hover:bg-brand-50"
          >
            <Pencil className="h-3.5 w-3.5" />
            Edit
          </button>
        </div>
        <dl className="mt-4 grid grid-cols-1 gap-4 sm:grid-cols-2">
          <div>
            <dt className="text-xs font-semibold uppercase tracking-wide text-ink-400">
              Severity
            </dt>
            <dd className="mt-0.5">
              {data.severity ? (
                <span
                  className={`inline-flex rounded-full border px-3 py-0.5 text-xs font-semibold ${SEVERITY_STYLES[data.severity as Severity]}`}
                >
                  {data.severity}
                </span>
              ) : (
                <span className="text-sm text-ink-800">—</span>
              )}
            </dd>
          </div>
          <ReviewItem label="Frequency" value={data.frequency} />
          <div className="sm:col-span-2">
            <ReviewItem label="Who is mainly affected" value={data.affectedGroup} />
          </div>
        </dl>
      </div>

      {/* Submit */}
      <div className="flex flex-col gap-3 pt-2 sm:flex-row sm:justify-end">
        <Button
          variant="primary"
          size="lg"
          onClick={onSubmit}
          disabled={submitting}
          className="w-full sm:w-auto"
        >
          {submitting ? 'Submitting…' : 'Submit Problem'}
        </Button>
      </div>
    </div>
  );
}
