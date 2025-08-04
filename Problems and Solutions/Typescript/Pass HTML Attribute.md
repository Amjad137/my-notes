import { HTMLAttributes } from 'react';

type Props<T> = {
  data: T[];
} & HTMLAttributes<HTMLDivElement>; // Add HTML div attributes to Props

const Combobox = <T extends { value: string; label: string }>({
  placeholder,
  data,
  onChange,
  className,
  ...rest // Destructure and spread the rest props
}: Props<T>) => {
  const [open, setOpen] = React.useState(false);
  const [value, setValue] = React.useState('');

  return (
    <div {...rest}> {/* Spread the rest props onto the div */}
      {/* Your existing JSX */}
    </div>
  );
};
