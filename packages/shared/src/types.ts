// Common types shared between backend and frontend

export interface UserRegistration {
  email: string;
  password: string;
  name: string;
}

export interface UserLogin {
  email: string;
  password: string;
}

export interface AuthToken {
  token: string;
  expiresIn: string;
}

export interface User {
  id: string;
  email: string;
  name: string;
  createdAt: string;
}

export interface ProfileCreateRequest {
  name: string;
  careerPath: 'TECH' | 'FINANCE' | 'CREATIVE' | 'HEALTHCARE';
  difficulty: 'BEGINNER' | 'STANDARD' | 'HARD';
}

export interface Profile {
  id: string;
  userId: string;
  cohortId: string;
  name: string;
  careerPath: string;
  currentWeek: number;
  gameStatus: 'ACTIVE' | 'BANKRUPT' | 'RETIRED';
  netWorth: number;
  creditScore: number;
  socialStatus: number;
  wellBeing: number;
  careerLevel: number;
  baseSalary: number;
  createdAt: string;
}

export interface ApiResponse<T> {
  success: boolean;
  data?: T;
  error?: string;
  timestamp: string;
}

export interface PaginationQuery {
  page: number;
  limit: number;
}
