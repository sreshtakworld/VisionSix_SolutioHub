import { ReactNode } from 'react';

interface FieldProps {
  label: string;
  required?: boolean;
  error?: string;
  children: ReactNode;
  htmlFor?: string;
}

export default function Field({ label, required, error, children, htmlFor }: FieldProps) {
  return (
    <div>
      <label
        htmlFor={htmlFor}
        className="block text-sm font-semibold text-ink-700"
      >
        {label}
        {required && <span className="ml-0.5 text-red-500">*</span>}
      </label>
      <div className="mt-1.5">{children}</div>
      {error && (
        <p className="mt-1.5 text-xs font-medium text-red-600">{error}</p>
      )}
    </div>
  );
}

const baseInputClass =
  'w-full rounded-xl border bg-white px-4 py-2.5 text-sm text-ink-800 placeholder:text-ink-400 transition-colors focus:outline-none focus:ring-2 focus:ring-brand-500/40';

export function inputClass(hasError?: boolean): string {
  return `${baseInputClass} ${hasError ? 'border-red-300' : 'border-ink-200 focus:border-brand-400'}`;
}

interface TextInputProps {
  id: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  hasError?: boolean;
  type?: string;
}

export function TextInput({
  id,
  value,
  onChange,
  placeholder,
  hasError,
  type = 'text',
}: TextInputProps) {
  return (
    <input
      id={id}
      type={type}
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      className={inputClass(hasError)}
    />
  );
}

interface TextAreaProps {
  id: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  hasError?: boolean;
  rows?: number;
}

export function TextArea({
  id,
  value,
  onChange,
  placeholder,
  hasError,
  rows = 4,
}: TextAreaProps) {
  return (
    <textarea
      id={id}
      value={value}
      onChange={(e) => onChange(e.target.value)}
      placeholder={placeholder}
      rows={rows}
      className={`${inputClass(hasError)} resize-none`}
    />
  );
}

interface SelectInputProps {
  id: string;
  value: string;
  onChange: (value: string) => void;
  placeholder?: string;
  hasError?: boolean;
  children: ReactNode;
}

export function SelectInput({
  id,
  value,
  onChange,
  placeholder,
  hasError,
  children,
}: SelectInputProps) {
  return (
    <select
      id={id}
      value={value}
      onChange={(e) => onChange(e.target.value)}
      className={`${inputClass(hasError)} appearance-none bg-[url('data:image/svg+xml;charset=US-ASCII,%3Csvg%20xmlns%3D%22http%3A%2F%2Fwww.w3.org%2F2000%2Fsvg%22%20width%3D%2212%22%20height%3D%2212%22%20fill%3D%22none%22%20stroke%3D%22%2364748b%22%20stroke-width%3D%222%22%3E%3Cpath%20d%3D%22M2%204l4%204%204-4%22%2F%3E%3C%2Fsvg%3E')] bg-[length:12px] bg-[right_1rem_center] bg-no-repeat pr-10`}
    >
      {placeholder && (
        <option value="" disabled>
          {placeholder}
        </option>
      )}
      {children}
    </select>
  );
}
