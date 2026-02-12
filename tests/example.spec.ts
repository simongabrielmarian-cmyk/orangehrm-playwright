import { test, expect } from '@playwright/test';

test('has login heading', async ({ page }) => {
  await page.goto('https://opensource-demo.orangehrmlive.com/web/index.php/auth/login');

  // Expect a paragraph to contain login string
  await expect(page.getByRole('heading', { name: 'Login' })).toHaveText('Login');

  // Expect Username and Password fields to be visible
  await expect(page.getByPlaceholder('Username')).toBeVisible();
  await expect(page.getByPlaceholder('Password')).toBeVisible();

  // Expect the Login button to be visible
  await expect(page.getByRole('button', { name: 'Login' })).toHaveText('Login');
  console.log('Login page is displayed correctly');
});

