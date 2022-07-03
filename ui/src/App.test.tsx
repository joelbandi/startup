import { render, screen } from '@testing-library/react';
import { App } from './App';

test('renders learn react link', () => {
  render(<App />);
  const elem = screen.getByText(/Backend/i);
  expect(elem).toBeInTheDocument();
});
