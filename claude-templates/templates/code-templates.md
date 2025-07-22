# Code Templates

## React Component Template
```typescript
import React, { FC, useState, useEffect } from 'react';
import { ComponentProps } from './types';
import styles from './Component.module.css';

export interface ComponentNameProps {
  // Define props here
}

export const ComponentName: FC<ComponentNameProps> = ({
  // Destructure props
}) => {
  // State and hooks
  const [state, setState] = useState<string>('');

  // Effects
  useEffect(() => {
    // Effect logic
  }, []);

  // Handlers
  const handleClick = () => {
    // Handler logic
  };

  // Render
  return (
    <div className={styles.container}>
      {/* Component content */}
    </div>
  );
};
```

## Express Endpoint Template
```typescript
import { Request, Response, NextFunction } from 'express';
import { body, validationResult } from 'express-validator';

// Validation middleware
export const validateEndpoint = [
  body('field').notEmpty().withMessage('Field is required'),
  body('email').isEmail().withMessage('Invalid email'),
];

// Handler
export const endpointHandler = async (
  req: Request,
  res: Response,
  next: NextFunction
) => {
  try {
    // Check validation
    const errors = validationResult(req);
    if (!errors.isEmpty()) {
      return res.status(400).json({ errors: errors.array() });
    }

    // Business logic
    const result = await processRequest(req.body);

    // Response
    res.status(200).json({
      success: true,
      data: result,
    });
  } catch (error) {
    next(error);
  }
};
```

## Test Template
```typescript
import { describe, it, expect, beforeEach, jest } from '@jest/globals';

describe('ComponentName', () => {
  let mockDependency: jest.Mock;

  beforeEach(() => {
    mockDependency = jest.fn();
    jest.clearAllMocks();
  });

  describe('feature', () => {
    it('should handle normal case', () => {
      // Arrange
      const input = 'test';
      const expected = 'TEST';

      // Act
      const result = functionUnderTest(input);

      // Assert
      expect(result).toBe(expected);
    });

    it('should handle edge case', () => {
      // Test edge cases
    });

    it('should handle error case', () => {
      // Test error scenarios
    });
  });
});
```

## Error Handler Template
```typescript
export class CustomError extends Error {
  constructor(
    message: string,
    public statusCode: number = 500,
    public code: string = 'INTERNAL_ERROR'
  ) {
    super(message);
    this.name = this.constructor.name;
    Error.captureStackTrace(this, this.constructor);
  }
}

export const errorHandler = (
  err: Error,
  req: Request,
  res: Response,
  next: NextFunction
) => {
  if (err instanceof CustomError) {
    return res.status(err.statusCode).json({
      error: {
        message: err.message,
        code: err.code,
      },
    });
  }

  // Log unexpected errors
  console.error('Unexpected error:', err);

  res.status(500).json({
    error: {
      message: 'Internal server error',
      code: 'INTERNAL_ERROR',
    },
  });
};
```